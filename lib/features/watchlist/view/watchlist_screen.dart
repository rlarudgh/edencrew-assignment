import 'package:edencrew_assignment_starter/app/routes.dart' as routes;
import 'package:edencrew_assignment_starter/domain/models/watchlist_item.dart';
import 'package:edencrew_assignment_starter/features/watchlist/widgets/watchlist_header.dart';
import 'package:edencrew_assignment_starter/providers/sorted_watchlist_provider.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_controller.dart';
import 'package:edencrew_assignment_starter/shared/widgets/empty_state.dart';
import 'package:edencrew_assignment_starter/shared/widgets/stock_row.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `01 · 관심` 화면입니다. 빈 상태(`01 · 관심_empty`)와 정렬
/// (`01 · 관심_sort`)을 모두 이 화면 안에서 처리합니다.
class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<WatchlistItem> items = ref.watch(sortedWatchlistProvider);
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            WatchlistHeader(
              onRefresh: () => ref.read(watchlistControllerProvider.notifier).refreshQuotes(),
            ),
            Expanded(
              child: items.isEmpty
                  ? const EmptyState(
                      icon: Icons.star_border,
                      title: '관심 종목이 없습니다',
                      message: '검색 탭에서 종목을 찾아\n별 아이콘을 눌러 추가해 주세요.',
                    )
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(height: 1, thickness: dimens.borderHairline, color: colors.borderSubtle),
                      itemBuilder: (BuildContext context, int index) {
                        final WatchlistItem item = items[index];
                        return StockRow(item: item, onTap: () => routes.pushDetail(context, item.stock));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
