import 'package:edencrew_assignment_starter/domain/models/market.dart';
import 'package:edencrew_assignment_starter/domain/models/search_result_item.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/providers/debounced_search_query_provider.dart';
import 'package:edencrew_assignment_starter/providers/search_query_provider.dart';
import 'package:edencrew_assignment_starter/providers/search_results_provider.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_stock_repository.dart';

const Stock _samsung = Stock(symbol: '005930', name: '삼성전자', market: Market.kospi);
const Stock _samsungPref = Stock(symbol: '005935', name: '삼성전자우', market: Market.kospi);

void main() {
  late FakeStockRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeStockRepository(
      defaultWatchlistSymbols: const <String>[],
      searchResultsByQuery: <String, List<Stock>>{
        '삼성': <Stock>[_samsung, _samsungPref],
      },
    );
    container = ProviderContainer(overrides: [stockRepositoryProvider.overrideWithValue(repository)]);
    addTearDown(container.dispose);
  });

  test('검색 결과에 관심 등록 여부가 정확히 반영된다', () async {
    // debouncedSearchQueryProvider는 처음 build될 때 searchQueryProvider를
    // 구독하기 시작하고 그 시점부터 디바운스 타이머가 돈다 — 그래서
    // searchQueryProvider를 갱신하기 전에 미리 한 번 읽어서 구독을
    // 시작해 둬야, 뒤에서 기다리는 300ms가 실제로 유효하다.
    container.read(debouncedSearchQueryProvider);

    // 삼성전자만 미리 관심 등록해 둔다. (기본 관심 목록 시드가 비어
    // 있어서 부트스트랩은 몇 번의 microtask 턴 안에 조용히 끝난다)
    container.read(watchlistControllerProvider);
    for (int i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration.zero);
    }
    await container.read(watchlistControllerProvider.notifier).toggleFavorite(_samsung);

    container.read(searchQueryProvider.notifier).update('삼성');
    // searchResultsProvider는 debouncedSearchQueryProvider(300ms 지연)를
    // 구독하므로, 그 이후에 조회가 시작된다.
    await Future<void>.delayed(const Duration(milliseconds: 350));

    List<SearchResultItem> items = <SearchResultItem>[];
    for (int i = 0; i < 20; i++) {
      final AsyncValue<List<SearchResultItem>> value = container.read(searchResultsProvider);
      if (value.hasValue && value.value!.isNotEmpty) {
        items = value.value!;
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    expect(items.length, 2);
    expect(items.firstWhere((SearchResultItem i) => i.stock.symbol == '005930').isFavorite, isTrue);
    expect(items.firstWhere((SearchResultItem i) => i.stock.symbol == '005935').isFavorite, isFalse);
  });

  test('검색어가 비어있으면 빈 목록을 반환한다', () async {
    container.read(searchResultsProvider);
    await Future<void>.delayed(Duration.zero);

    final AsyncValue<List<SearchResultItem>> value = container.read(searchResultsProvider);
    expect(value.value, isEmpty);
  });
}
