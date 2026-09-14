import 'package:edencrew_assignment_starter/domain/models/daily_price_row.dart';
import 'package:edencrew_assignment_starter/domain/models/price_direction.dart';
import 'package:edencrew_assignment_starter/formatting/number_formatting.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 일별 시세 표입니다. 컬럼: 날짜, 종가, 등락, 거래량.
class DailyPriceTable extends StatelessWidget {
  const DailyPriceTable({super.key, required this.rows});

  final List<DailyPriceRow> rows;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '일별 시세',
            style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: AppTypography.bold),
          ),
          SizedBox(height: dimens.space2),
          _HeaderRow(colors: colors, dimens: dimens),
          Divider(height: 1, thickness: dimens.borderHairline, color: colors.borderSubtle),
          for (final DailyPriceRow row in rows) ...<Widget>[
            _DataRow(row: row, colors: colors, dimens: dimens),
            Divider(height: 1, thickness: dimens.borderHairline, color: colors.borderSubtle),
          ],
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.colors, required this.dimens});

  final AppColors colors;
  final AppDimens dimens;

  TextStyle get _style => TextStyle(color: colors.textTertiary, fontSize: 12, fontWeight: AppTypography.regular);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dimens.space2),
      child: Row(
        children: <Widget>[
          Expanded(flex: 2, child: Text('날짜', style: _style)),
          Expanded(flex: 2, child: Text('종가', textAlign: TextAlign.right, style: _style)),
          Expanded(flex: 2, child: Text('등락', textAlign: TextAlign.right, style: _style)),
          Expanded(flex: 3, child: Text('거래량', textAlign: TextAlign.right, style: _style)),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.row, required this.colors, required this.dimens});

  final DailyPriceRow row;
  final AppColors colors;
  final AppDimens dimens;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = TextStyle(
      color: colors.textPrimary,
      fontSize: 13,
      fontWeight: AppTypography.regular,
    );
    final Color changeColor = switch (row.direction) {
      PriceDirection.up => colors.priceUpText,
      PriceDirection.down => colors.priceDownText,
      PriceDirection.flat => colors.textSecondary,
    };

    return Padding(
      padding: EdgeInsets.symmetric(vertical: dimens.space2),
      child: Row(
        children: <Widget>[
          Expanded(flex: 2, child: Text(NumberFormatting.monthDay(row.date), style: baseStyle)),
          Expanded(
            flex: 2,
            child: Text(NumberFormatting.comma(row.close), textAlign: TextAlign.right, style: baseStyle),
          ),
          Expanded(
            flex: 2,
            child: Text(
              NumberFormatting.signedAmount(row.changeAmount),
              textAlign: TextAlign.right,
              style: baseStyle.copyWith(color: changeColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(NumberFormatting.comma(row.volume), textAlign: TextAlign.right, style: baseStyle),
          ),
        ],
      ),
    );
  }
}
