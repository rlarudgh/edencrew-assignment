import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/formatting/number_formatting.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 시가/고가/저가/거래량/시가총액 요약 카드입니다. 거래량과 시가총액은
/// 축약해서 표기합니다. (예: 29,113천, 1,063조)
class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final AppDimens dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space2),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _Cell(label: '시가', value: NumberFormatting.comma(quote.open)),
              SizedBox(width: dimens.space2),
              _Cell(label: '고가', value: NumberFormatting.comma(quote.high)),
              SizedBox(width: dimens.space2),
              _Cell(label: '저가', value: NumberFormatting.comma(quote.low)),
            ],
          ),
          SizedBox(height: dimens.space2),
          Row(
            children: <Widget>[
              _Cell(label: '거래량', value: NumberFormatting.volumeInThousands(quote.volume)),
              SizedBox(width: dimens.space2),
              _Cell(label: '시가총액', value: NumberFormatting.marketCapInTrillions(quote.marketCap)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.label, required this.value});

  final String label;
  final String value;

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
            Text(
              value,
              style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: AppTypography.bold),
            ),
          ],
        ),
      ),
    );
  }
}
