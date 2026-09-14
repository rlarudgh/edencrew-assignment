import 'package:edencrew_assignment_starter/features/watchlist/widgets/sort_chip.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 관심 화면 상단 헤더입니다. 제목 + 정렬 칩 + 새로고침 버튼으로
/// 구성됩니다. 빈 상태에서도 이 헤더는 그대로 유지됩니다.
class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({super.key, required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space4, dimens.space4, dimens.space2, dimens.space2),
      child: Row(
        children: <Widget>[
          Text('관심', style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: AppTypography.bold)),
          const Spacer(),
          const SortChip(),
          SizedBox(width: dimens.space1),
          IconButton(onPressed: onRefresh, icon: Icon(Icons.refresh, color: colors.textSecondary)),
        ],
      ),
    );
  }
}
