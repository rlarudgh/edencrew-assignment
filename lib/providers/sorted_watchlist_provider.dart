import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/sort_option.dart';
import 'package:edencrew_assignment_starter/domain/models/watchlist_item.dart';
import 'package:edencrew_assignment_starter/providers/sort_option_provider.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_controller.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [watchlistControllerProvider]와 [sortOptionProvider]를 합쳐 실제로
/// 화면에 그릴 정렬된 관심 목록을 계산하는 파생 provider입니다.
///
/// 정렬 로직을 컨트롤러 밖으로 빼서, "관심 등록/해제"와 "표시 순서"의
/// 책임을 분리했습니다.
final Provider<List<WatchlistItem>> sortedWatchlistProvider = Provider<List<WatchlistItem>>((Ref ref) {
  final WatchlistState state = ref.watch(watchlistControllerProvider);
  final SortOption sortOption = ref.watch(sortOptionProvider);

  final List<WatchlistItem> items = state.memberSymbols
      .map(
        (String symbol) => WatchlistItem(
          stock: state.stocksBySymbol[symbol]!,
          quote: state.quotesBySymbol[symbol],
        ),
      )
      .toList();

  // 시세를 아직 못 받은 행은 0으로 취급하지 않고 항상 뒤로 보냅니다.
  // (현재가순/등락률순에서 로딩 중인 행이 엉뚱한 위치에 잠깐 나타나는 걸
  // 막기 위한 직접 판단 — Figma에 정의되어 있지 않습니다.)
  int compareLoadedLast(WatchlistItem a, WatchlistItem b, int Function(Quote, Quote) compare) {
    final Quote? quoteA = a.quote;
    final Quote? quoteB = b.quote;
    if (quoteA == null && quoteB == null) return 0;
    if (quoteA == null) return 1;
    if (quoteB == null) return -1;
    return compare(quoteA, quoteB);
  }

  switch (sortOption) {
    case SortOption.priceDesc:
      items.sort(
        (WatchlistItem a, WatchlistItem b) =>
            compareLoadedLast(a, b, (Quote qa, Quote qb) => qb.currentPrice.compareTo(qa.currentPrice)),
      );
    case SortOption.changeRateDesc:
      items.sort(
        (WatchlistItem a, WatchlistItem b) =>
            compareLoadedLast(a, b, (Quote qa, Quote qb) => qb.changeRate.compareTo(qa.changeRate)),
      );
    case SortOption.nameAsc:
      items.sort((WatchlistItem a, WatchlistItem b) => a.stock.name.compareTo(b.stock.name));
  }

  return items;
});
