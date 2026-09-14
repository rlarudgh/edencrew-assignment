import 'package:edencrew_assignment_starter/app/routes.dart' as routes;
import 'package:edencrew_assignment_starter/domain/models/search_result_item.dart';
import 'package:edencrew_assignment_starter/features/search/widgets/search_field.dart';
import 'package:edencrew_assignment_starter/features/search/widgets/search_result_row.dart';
import 'package:edencrew_assignment_starter/features/search/widgets/search_result_skeleton_row.dart';
import 'package:edencrew_assignment_starter/providers/debounced_search_query_provider.dart';
import 'package:edencrew_assignment_starter/providers/search_results_provider.dart';
import 'package:edencrew_assignment_starter/shared/widgets/empty_state.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `02 · 검색` 화면입니다. 초기 상태(`02 · 검색_empty`)와 결과 없음
/// (`02 · 검색결과_empty`)을 모두 이 화면 안에서 처리합니다.
class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 결과 목록/빈 상태 분기와 검색 결과 하이라이트는 실제로 검색이
    // 실행된(디바운스된) 검색어를 기준으로 합니다 — 입력창 자체는
    // SearchField가 raw 검색어로 즉시 반응합니다.
    final String query = ref.watch(debouncedSearchQueryProvider);
    final AsyncValue<List<SearchResultItem>> results = ref.watch(searchResultsProvider);
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SearchField(),
            Expanded(
              child: query.trim().isEmpty
                  ? const EmptyState(
                      icon: Icons.search,
                      title: '종목을 검색해 보세요',
                      message: '종목명 또는 종목코드 6자리로\n검색하실 수 있습니다.',
                    )
                  : results.when(
                      loading: () => ListView.separated(
                        itemCount: 6,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 1, thickness: dimens.borderHairline, color: colors.borderSubtle),
                        itemBuilder: (BuildContext context, int index) => const SearchResultSkeletonRow(),
                      ),
                      error: (Object error, StackTrace stackTrace) => const EmptyState(
                        icon: Icons.error_outline,
                        title: '검색 중 문제가 발생했습니다',
                        message: '잠시 후 다시 시도해 주세요.',
                      ),
                      data: (List<SearchResultItem> items) {
                        if (items.isEmpty) {
                          return EmptyState(
                            icon: Icons.search_off,
                            title: '검색 결과가 없습니다',
                            message: "'$query'와\n일치하는 검색 결과를 찾지 못했습니다.",
                          );
                        }
                        return ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(height: 1, thickness: dimens.borderHairline, color: colors.borderSubtle),
                          itemBuilder: (BuildContext context, int index) {
                            final SearchResultItem item = items[index];
                            return SearchResultRow(
                              item: item,
                              query: query,
                              onTap: () => routes.pushDetail(context, item.stock),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
