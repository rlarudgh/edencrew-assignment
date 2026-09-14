import 'package:edencrew_assignment_starter/domain/models/market.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/sort_option.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/domain/models/watchlist_item.dart';
import 'package:edencrew_assignment_starter/providers/sort_option_provider.dart';
import 'package:edencrew_assignment_starter/providers/sorted_watchlist_provider.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_stock_repository.dart';

const Stock _samsung = Stock(symbol: '005930', name: '삼성전자', market: Market.kospi);
const Stock _hynix = Stock(symbol: '000660', name: 'SK하이닉스', market: Market.kospi);
const Stock _kakao = Stock(symbol: '035720', name: '카카오', market: Market.kospi);

Quote _quote({required int price, required int prevClose}) => Quote(
  currentPrice: price,
  previousClose: prevClose,
  open: price,
  high: price,
  low: price,
  volume: 1000,
  marketCap: 1000,
);

void main() {
  late FakeStockRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeStockRepository(
      defaultWatchlistSymbols: <String>['005930', '000660', '035720'],
      stocksBySymbol: <String, Stock>{'005930': _samsung, '000660': _hynix, '035720': _kakao},
      quotesBySymbol: <String, Quote>{
        '005930': _quote(price: 100000, prevClose: 100000), // 보합
        '000660': _quote(price: 200000, prevClose: 100000), // +100%, 가장 비쌈
        // 035720은 시세를 아직 안 넣어서 항상 뒤로 가야 한다.
      },
    );
    container = ProviderContainer(overrides: [stockRepositoryProvider.overrideWithValue(repository)]);
    addTearDown(container.dispose);
  });

  // watchlistControllerProvider는 첫 read/watch 때 build()가 실행되면서
  // 부트스트랩(microtask)이 예약된다 — 그래서 먼저 읽어서 트리거한 뒤,
  // memberSymbols가 채워질 때까지 기다려야 한다.
  Future<void> waitForBootstrap() async {
    container.read(watchlistControllerProvider);
    for (int i = 0; i < 50; i++) {
      if (container.read(watchlistControllerProvider).memberSymbols.length == 3) return;
      await Future<void>.delayed(Duration.zero);
    }
    fail('부트스트랩이 제한 시간 안에 끝나지 않았다');
  }

  test('현재가순: 가격 높은 순, 시세 미도착 행은 항상 뒤로', () async {
    await waitForBootstrap();
    container.read(sortOptionProvider.notifier).select(SortOption.priceDesc);

    final List<WatchlistItem> items = container.read(sortedWatchlistProvider);
    expect(items.map((WatchlistItem i) => i.stock.symbol).toList(), <String>['000660', '005930', '035720']);
  });

  test('등락률순: 등락률 높은 순, 시세 미도착 행은 항상 뒤로', () async {
    await waitForBootstrap();
    container.read(sortOptionProvider.notifier).select(SortOption.changeRateDesc);

    final List<WatchlistItem> items = container.read(sortedWatchlistProvider);
    expect(items.map((WatchlistItem i) => i.stock.symbol).toList(), <String>['000660', '005930', '035720']);
  });

  test('가나다순: 이름 오름차순 (시세 유무와 무관)', () async {
    await waitForBootstrap();
    container.read(sortOptionProvider.notifier).select(SortOption.nameAsc);

    final List<WatchlistItem> items = container.read(sortedWatchlistProvider);
    final List<String> names = items.map((WatchlistItem i) => i.stock.name).toList();
    // String.compareTo는 코드 유닛 비교라 알파벳(SK하이닉스)이 한글보다
    // 앞에 온다 — 정렬 결과가 오름차순인지(원본 리스트 정렬 후와 동일한지)만
    // 확인한다.
    final List<String> expected = <String>['삼성전자', 'SK하이닉스', '카카오']..sort();
    expect(names, expected);
  });
}
