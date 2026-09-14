import 'package:edencrew_assignment_starter/domain/models/search_result_item.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/providers/debounced_search_query_provider.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 검색어에 맞는 결과를 조회하고, 각 종목의 관심 등록 여부를 함께
/// 계산합니다. 검색 화면은 자체적으로 관심 상태를 들고 있지 않고 항상
/// [watchlistControllerProvider]를 조회합니다.
///
/// 타이핑 중인 raw 검색어가 아니라 [debouncedSearchQueryProvider]를
/// 구독해서, 입력이 멈춘 뒤에만 실제 API 호출이 나갑니다.
final FutureProvider<List<SearchResultItem>> searchResultsProvider =
    FutureProvider<List<SearchResultItem>>((Ref ref) async {
      final String query = ref.watch(debouncedSearchQueryProvider);
      if (query.trim().isEmpty) return const <SearchResultItem>[];

      final List<Stock> stocks = await ref.read(stockRepositoryProvider).searchStocks(query);
      final bool Function(String) isFavorite = ref.watch(watchlistControllerProvider).isFavorite;

      return stocks
          .map((Stock stock) => SearchResultItem(stock: stock, isFavorite: isFavorite(stock.symbol)))
          .toList();
    });
