import 'package:edencrew_assignment_starter/shared/widgets/skeleton_box.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 검색 결과가 도착하기 전에 보여주는 스켈레톤 행입니다.
///
/// `SearchResultRow`와 같은 자리(이름/코드 자리, 별 아이콘 자리)에
/// `SkeletonBox`를 배치해서, 결과가 도착했을 때 레이아웃이 흔들리지
/// 않게 합니다.
class SearchResultSkeletonRow extends StatelessWidget {
  const SearchResultSkeletonRow({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDimens dimens = context.dimens;

    return Container(
      constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
      padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space3),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SkeletonBox(width: 120, height: 18),
                SizedBox(height: dimens.space1),
                const SkeletonBox(width: 80, height: 13),
              ],
            ),
          ),
          SizedBox(width: dimens.space3),
          SkeletonBox(width: dimens.iconMd, height: dimens.iconMd, borderRadius: dimens.iconMd / 2),
        ],
      ),
    );
  }
}
