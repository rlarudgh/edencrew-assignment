import 'package:edencrew_assignment_starter/domain/models/sort_option.dart';
import 'package:edencrew_assignment_starter/features/watchlist/widgets/sort_bottom_sheet.dart';
import 'package:edencrew_assignment_starter/providers/sort_option_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 현재 정렬 기준을 보여주고, 누르면 정렬 바텀시트를 여는 칩입니다.
class SortChip extends ConsumerWidget {
  const SortChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SortOption sortOption = ref.watch(sortOptionProvider);
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return InkWell(
      borderRadius: BorderRadius.circular(dimens.radiusMd),
      onTap: () => showSortBottomSheet(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimens.space2, vertical: dimens.space1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              sortOption.label,
              style: TextStyle(color: colors.textSecondary, fontSize: 14, fontWeight: AppTypography.medium),
            ),
            Icon(Icons.keyboard_arrow_down, color: colors.textSecondary, size: dimens.iconSm),
          ],
        ),
      ),
    );
  }
}
