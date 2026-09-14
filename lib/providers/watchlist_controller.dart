import 'package:edencrew_assignment_starter/data/stock_repository.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 관심 목록의 유일한 진실 공급원(single source of truth)입니다.
///
/// 관심/검색/상세 3화면 모두 이 provider만 구독하고, 즐겨찾기 변경은 항상
/// [toggleFavorite] 하나를 통해서만 이루어집니다. 그래야 세 화면의 별
/// 아이콘과 시세가 항상 같은 값을 보여준다는 걸 보장할 수 있습니다.
class WatchlistController extends Notifier<WatchlistState> {
  @override
  WatchlistState build() {
    // build()는 동기적으로 빈 상태만 반환하고, 실제 부트스트랩은 build가
    // 끝난 뒤(microtask)에 시작합니다. 실제 API는 종목 이름/시장을
    // 비동기로만 알 수 있어서(엔드포인트 3), 시드 단계부터 이미 비동기입니다.
    Future<void>.microtask(_bootstrap);
    return const WatchlistState();
  }

  Future<void> _bootstrap() async {
    final StockRepository repository = ref.read(stockRepositoryProvider);
    final List<String> seedSymbols = repository.defaultWatchlistSymbols;

    // 이름/시장이 확정된 종목만 memberSymbols에 넣습니다 — 그래야
    // sortedWatchlistProvider의 stocksBySymbol[symbol]! 이 항상 안전합니다.
    // 시세(quote)는 아직 null이라 이 시점엔 스켈레톤으로 보입니다.
    final List<Stock> resolvedStocks = await Future.wait(seedSymbols.map(repository.fetchStockInfo));

    state = state.copyWith(
      stocksBySymbol: <String, Stock>{for (final Stock stock in resolvedStocks) stock.symbol: stock},
      memberSymbols: resolvedStocks.map((Stock stock) => stock.symbol).toList(),
      quotesBySymbol: <String, Quote?>{for (final Stock stock in resolvedStocks) stock.symbol: null},
    );

    await refreshQuotes();
  }

  /// 관심 등록 / 해제를 토글합니다. 검색·상세 화면 모두 이 메서드를
  /// 호출합니다 — 두 번째 변경 경로를 만들지 않기 위해서입니다.
  Future<void> toggleFavorite(Stock stock) async {
    final bool alreadyFavorite = state.isFavorite(stock.symbol);
    final Map<String, Stock> updatedStocks = <String, Stock>{
      ...state.stocksBySymbol,
      stock.symbol: stock,
    };

    if (alreadyFavorite) {
      state = state.copyWith(
        stocksBySymbol: updatedStocks,
        memberSymbols: state.memberSymbols.where((String symbol) => symbol != stock.symbol).toList(),
      );
      return;
    }

    state = state.copyWith(
      stocksBySymbol: updatedStocks,
      memberSymbols: <String>[...state.memberSymbols, stock.symbol],
    );

    // 관심 등록 전 검색 결과에서는 시세를 안 받았을 수 있으니, 없으면
    // 이번에 조회합니다.
    if (state.quotesBySymbol[stock.symbol] == null) {
      final Map<String, Quote> fetched = await ref
          .read(stockRepositoryProvider)
          .fetchQuotes(<String>[stock.symbol]);
      final Quote? quote = fetched[stock.symbol];
      if (quote != null && state.isFavorite(stock.symbol)) {
        state = state.copyWith(quotesBySymbol: <String, Quote?>{...state.quotesBySymbol, stock.symbol: quote});
      }
    }
  }

  /// 현재 관심 등록된 모든 종목의 시세를 한 번에 다시 조회합니다.
  /// (상단 새로고침 버튼 / 초기 로딩에서 사용)
  Future<void> refreshQuotes() async {
    if (state.memberSymbols.isEmpty) return;
    state = state.copyWith(isRefreshing: true);

    final Map<String, Quote> fetched = await ref
        .read(stockRepositoryProvider)
        .fetchQuotes(state.memberSymbols);

    state = state.copyWith(
      quotesBySymbol: <String, Quote?>{...state.quotesBySymbol, ...fetched},
      isRefreshing: false,
    );
  }
}

final NotifierProvider<WatchlistController, WatchlistState> watchlistControllerProvider =
    NotifierProvider<WatchlistController, WatchlistState>(WatchlistController.new);
