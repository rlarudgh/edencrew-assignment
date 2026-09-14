import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 로딩 중인 자리를 대신 채우는 회색 박스입니다.
///
/// 관심 목록(`StockRow`)에서 쓰던 스켈레톤 색 박스를 검색/상세 화면에서도
/// 같은 톤으로 재사용하기 위해 공용 위젯으로 뽑았습니다. `feedbackSkeleton`
/// 토큰만 쓰고, 실제 콘텐츠와 같은 자리에 같은 크기로 놓아서 데이터가
/// 도착했을 때 레이아웃이 움직이지 않게 하는 용도입니다.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, required this.width, required this.height, this.borderRadius = 4});

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.feedbackSkeleton,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
