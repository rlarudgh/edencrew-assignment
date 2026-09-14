import 'package:edencrew_assignment_starter/shared/widgets/skeleton_box.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 일별 시세가 도착하기 전 `CandleChart` 자리에 보여주는 스켈레톤입니다.
/// 차트와 같은 높이의 박스 하나로, 데이터가 오면 같은 자리에서 바로
/// 차트로 바뀝니다.
class CandleChartSkeleton extends StatelessWidget {
  const CandleChartSkeleton({super.key, this.height = 180});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.dimens.space4),
      child: SkeletonBox(width: double.infinity, height: height, borderRadius: 8),
    );
  }
}
