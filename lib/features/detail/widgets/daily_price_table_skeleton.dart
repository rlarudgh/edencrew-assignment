import 'package:edencrew_assignment_starter/shared/widgets/skeleton_box.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 일별 시세가 도착하기 전 `DailyPriceTable` 자리에 보여주는
/// 스켈레톤입니다. 헤더(날짜/종가/등락/거래량)는 고정 텍스트라 그대로
/// 다시 그리고, 데이터 행 자리만 `SkeletonBox`로 채웁니다.
class DailyPriceTableSkeleton extends StatelessWidget {
  const DailyPriceTableSkeleton({super.key, this.rowCount = 5});

  final int rowCount;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final TextStyle headerStyle = TextStyle(
      color: colors.textTertiary,
      fontSize: 12,
      fontWeight: AppTypography.regular,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '일별 시세',
            style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: AppTypography.bold),
          ),
          SizedBox(height: dimens.space2),
          Padding(
            padding: EdgeInsets.symmetric(vertical: dimens.space2),
            child: Row(
              children: <Widget>[
                Expanded(flex: 2, child: Text('날짜', style: headerStyle)),
                Expanded(flex: 2, child: Text('종가', textAlign: TextAlign.right, style: headerStyle)),
                Expanded(flex: 2, child: Text('등락', textAlign: TextAlign.right, style: headerStyle)),
                Expanded(flex: 3, child: Text('거래량', textAlign: TextAlign.right, style: headerStyle)),
              ],
            ),
          ),
          Divider(height: 1, thickness: dimens.borderHairline, color: colors.borderSubtle),
          for (int i = 0; i < rowCount; i++) ...<Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: dimens.space2),
              child: const Row(
                children: <Widget>[
                  Expanded(flex: 2, child: SkeletonBox(width: 44, height: 13)),
                  SizedBox(width: 8),
                  Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: SkeletonBox(width: 56, height: 13))),
                  SizedBox(width: 8),
                  Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: SkeletonBox(width: 40, height: 13))),
                  SizedBox(width: 8),
                  Expanded(flex: 3, child: Align(alignment: Alignment.centerRight, child: SkeletonBox(width: 64, height: 13))),
                ],
              ),
            ),
            Divider(height: 1, thickness: dimens.borderHairline, color: colors.borderSubtle),
          ],
        ],
      ),
    );
  }
}
