import 'package:edencrew_assignment_starter/shared/widgets/skeleton_box.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 시세가 도착하기 전 `PriceHero` 자리에 보여주는 스켈레톤입니다. 같은
/// 패딩/자리에 큰 바(가격) + 작은 바(등락)를 놓아 레이아웃을 맞춥니다.
class PriceHeroSkeleton extends StatelessWidget {
  const PriceHeroSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDimens dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SkeletonBox(width: 160, height: 32),
          SizedBox(height: dimens.space2),
          const SkeletonBox(width: 120, height: 16),
        ],
      ),
    );
  }
}
