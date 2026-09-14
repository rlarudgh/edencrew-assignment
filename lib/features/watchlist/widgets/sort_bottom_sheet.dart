import 'package:edencrew_assignment_starter/domain/models/sort_option.dart';
import 'package:edencrew_assignment_starter/providers/sort_option_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 정렬 바텀시트를 엽니다. (`01 · 관심_sort` 프레임)
void showSortBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => const _SortBottomSheetContent(),
  );
}

class _SortBottomSheetContent extends ConsumerWidget {
  const _SortBottomSheetContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final SortOption selected = ref.watch(sortOptionProvider);

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(dimens.space5),
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.vertical(top: Radius.circular(dimens.radiusLg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('정렬', style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: AppTypography.bold)),
            SizedBox(height: dimens.space3),
            for (final SortOption option in SortOption.values)
              InkWell(
                onTap: () {
                  ref.read(sortOptionProvider.notifier).select(option);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: dimens.space3),
                  child: Row(
                    children: <Widget>[
                      Text(
                        option.label,
                        style: TextStyle(
                          color: option == selected ? colors.textPrimary : colors.textSecondary,
                          fontSize: 15,
                          fontWeight: AppTypography.medium,
                        ),
                      ),
                      const Spacer(),
                      if (option == selected) Icon(Icons.check, color: colors.textPrimary),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
