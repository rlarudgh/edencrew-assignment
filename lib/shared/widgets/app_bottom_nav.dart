import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 관심/검색 하단 탭 바입니다. `navActive`/`navInactive` 토큰으로 선택
/// 상태를 구분합니다.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    // 커스텀 위젯이라 Scaffold가 자동으로 홈 인디케이터 영역을 안전하게
    // 비워주지 않습니다. 배경은 화면 맨 아래까지 채우되, 탭 내용은 그
    // 영역 위로 올라오도록 하단 세이프에어리어만큼 패딩을 더합니다.
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: colors.surfaceBase,
        border: Border(top: BorderSide(color: colors.borderSubtle, width: dimens.borderHairline)),
      ),
      child: SizedBox(
        height: dimens.tabBarHeight,
        child: Row(
          children: <Widget>[
            _NavItem(
              icon: Icons.star,
              label: '관심',
              selected: currentIndex == 0,
              colors: colors,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.search,
              label: '검색',
              selected: currentIndex == 1,
              colors: colors,
              onTap: () => onTap(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final AppColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? colors.navActive : colors.navInactive;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: AppTypography.medium)),
          ],
        ),
      ),
    );
  }
}
