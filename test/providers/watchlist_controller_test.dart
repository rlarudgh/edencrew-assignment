import 'package:edencrew_assignment_starter/domain/models/market.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_controller.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_stock_repository.dart';

const Stock _samsung = Stock(symbol: '005930', name: '삼성전자', market: Market.kospi);
const Stock _hynix = Stock(symbol: '000660', name: 'SK하이닉스', market: Market.kospi);
const Quote _samsungQuote = Quote(
  currentPrice: 179700,
  previousClose: 180100,
  open: 172100,
  high: 181700,
  low: 172000,
  volume: 29113466,
  marketCap: 1063000000000000,
);

void main() {
  late FakeStockRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeStockRepository(
      defaultWatchlistSymbols: <String>['005930'],
      stocksBySymbol: <String, Stock>{'005930': _samsung, '000660': _hynix},
      quotesBySymbol: <String, Quote>{'005930': _samsungQuote},
    );
    container = ProviderContainer(overrides: [stockRepositoryProvider.overrideWithValue(repository)]);
    addTearDown(container.dispose);
  });

  // watchlistControllerProvider는 첫 read/watch 때 build()가 실행되면서
  // 부트스트랩(microtask)이 예약된다 — 그래서 먼저 읽어서 트리거한 뒤,
  // memberSymbols가 채워질 때까지 기다려야 한다. (그냥 delay를 몇 번
  // 넣는 방식은 부트스트랩과 toggleFavorite의 실행 순서가 뒤섞이는
  // 경합을 만들 수 있어 폴링으로 명시적으로 기다린다.)
  Future<void> waitForBootstrap() async {
    container.read(watchlistControllerProvider);
    for (int i = 0; i < 50; i++) {
      if (container.read(watchlistControllerProvider).memberSymbols.isNotEmpty) return;
      await Future<void>.delayed(Duration.zero);
    }
    fail('부트스트랩이 제한 시간 안에 끝나지 않았다');
  }

  test('부트스트랩: 이름이 확정된 후에만 목록에 노출되고, 시세는 배치로 채워진다', () async {
    // 최초 build 직후엔 아직 부트스트랩(microtask) 전이라 비어 있다.
    expect(container.read(watchlistControllerProvider).memberSymbols, isEmpty);

    await waitForBootstrap();

    final WatchlistState state = container.read(watchlistControllerProvider);
    expect(state.memberSymbols, <String>['005930']);
    expect(state.stocksBySymbol['005930'], _samsung);
    expect(state.quotesBySymbol['005930'], _samsungQuote);

    // 관심 목록 전체 시세를 한 번에(배치로) 조회해야 한다.
    expect(repository.fetchQuotesCalls, isNotEmpty);
    expect(repository.fetchQuotesCalls.first, <String>['005930']);
  });

  test('toggleFavorite: 없으면 추가하고 시세도 채우며, 있으면 제거한다', () async {
    await waitForBootstrap();

    final WatchlistController controller = container.read(watchlistControllerProvider.notifier);

    // SK하이닉스는 처음엔 관심 목록에 없다.
    expect(container.read(watchlistControllerProvider).isFavorite('000660'), isFalse);

    repository.setQuote(
      '000660',
      const Quote(
        currentPrice: 412500,
        previousClose: 403000,
        open: 405000,
        high: 415000,
        low: 402500,
        volume: 4123456,
        marketCap: 300000000000000,
      ),
    );
    await controller.toggleFavorite(_hynix);

    WatchlistState state = container.read(watchlistControllerProvider);
    expect(state.isFavorite('000660'), isTrue);
    expect(state.quotesBySymbol['000660']?.currentPrice, 412500);

    // 다시 누르면 해제된다.
    await controller.toggleFavorite(_hynix);
    state = container.read(watchlistControllerProvider);
    expect(state.isFavorite('000660'), isFalse);
  });
}
