import 'package:edencrew_assignment_starter/shared/widgets/skeleton_box.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 시세가 도착하기 전 `SummaryCard` 자리에 보여주는 스켈레톤입니다.
/// 라벨(시가/고가/저가/거래량/시가총액)은 고정 텍스트라 그대로 두고,
/// 값 자리만 `SkeletonBox`로 채웁니다.
class SummaryCardSkeleton extends StatelessWidget {
  const SummaryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDimens dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space2),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _Cell(label: '시가'),
              SizedBox(width: dimens.space2),
              _Cell(label: '고가'),
              SizedBox(width: dimens.space2),
              _Cell(label: '저가'),
            ],
          ),
          SizedBox(height: dimens.space2),
          Row(
            children: <Widget>[
              _Cell(label: '거래량'),
              SizedBox(width: dimens.space2),
              _Cell(label: '시가총액'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(dimens.space3),
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(dimens.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(color: colors.textSecondary, fontSize: 12, fontWeight: AppTypography.regular),
            ),
            SizedBox(height: dimens.space1),
            const SkeletonBox(width: 56, height: 15),
          ],
        ),
      ),
    );
  }
}
