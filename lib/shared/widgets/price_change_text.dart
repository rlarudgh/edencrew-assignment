import 'package:edencrew_assignment_starter/domain/models/price_direction.dart';
import 'package:edencrew_assignment_starter/formatting/number_formatting.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// "±금액 (±비율%)" 형태의 등락 텍스트입니다. 방향에 따라 색이 바뀝니다.
class PriceChangeText extends StatelessWidget {
  const PriceChangeText({
    super.key,
    required this.changeAmount,
    required this.changeRate,
    this.fontSize = 13,
    this.fontWeight,
  });

  final int changeAmount;
  final double changeRate;
  final double fontSize;
  final FontWeight? fontWeight;

  PriceDirection get _direction {
    if (changeAmount > 0) return PriceDirection.up;
    if (changeAmount < 0) return PriceDirection.down;
    return PriceDirection.flat;
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color color = switch (_direction) {
      PriceDirection.up => colors.priceUpText,
      PriceDirection.down => colors.priceDownText,
      PriceDirection.flat => colors.priceFlatText,
    };

    return Text(
      NumberFormatting.changeLine(changeAmount, changeRate),
      style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight ?? AppTypography.medium),
    );
  }
}
