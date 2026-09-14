import 'package:edencrew_assignment_starter/domain/models/period_option.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 기간 탭 (1개월/3개월/6개월/1년)입니다. 선택된 탭은 `accentBg`/
/// `accentDefault` 스타일이 적용됩니다.
class PeriodTabs extends StatelessWidget {
  const PeriodTabs({super.key, required this.selected, required this.onSelected});

  final PeriodOption selected;
  final ValueChanged<PeriodOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppDimens dimens = context.dimens;

    // 4개 탭이 같은 너비로 4분할되는 그리드처럼 보이도록 각 탭을
    // Expanded로 감쌉니다. 탭 사이에만 간격을 넣고, 좌우 바깥 여백은
    // 화면 기준 16px(space4) 정확히 맞춥니다 — 탭마다 자체 좌우
    // padding을 두면 바깥 여백에 겹쳐 더 넓어 보이는 문제가 있었습니다.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space2),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < PeriodOption.values.length; i++) ...<Widget>[
            if (i > 0) SizedBox(width: dimens.space2),
            Expanded(child: _PeriodTab(option: PeriodOption.values[i], selected: selected, onSelected: onSelected)),
          ],
        ],
      ),
    );
  }
}

class _PeriodTab extends StatelessWidget {
  const _PeriodTab({required this.option, required this.selected, required this.onSelected});

  final PeriodOption option;
  final PeriodOption selected;
  final ValueChanged<PeriodOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final bool isSelected = option == selected;

    return InkWell(
      borderRadius: BorderRadius.circular(dimens.radiusMd),
      onTap: () => onSelected(option),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: dimens.space2),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentBg : Colors.transparent,
          borderRadius: BorderRadius.circular(dimens.radiusMd),
        ),
        child: Text(
          option.label,
          style: TextStyle(
            color: isSelected ? colors.accentDefault : colors.textSecondary,
            fontSize: 14,
            fontWeight: AppTypography.medium,
          ),
        ),
      ),
    );
  }
}
