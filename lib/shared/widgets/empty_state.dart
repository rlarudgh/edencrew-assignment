import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 관심종목 없음 / 검색 전 / 검색 결과 없음에서 공통으로 쓰는 빈 상태
/// 위젯입니다. 헤더와 하단 탭 바는 그대로 유지된 채 본문(Expanded) 안에
/// 배치되도록 설계했습니다.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimens.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 48, color: colors.textDisabled),
            SizedBox(height: dimens.space4),
            Text(
              title,
              style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: AppTypography.bold),
            ),
            SizedBox(height: dimens.space2),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 13,
                fontWeight: AppTypography.regular,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
