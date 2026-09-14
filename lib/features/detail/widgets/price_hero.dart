import 'package:edencrew_assignment_starter/domain/models/price_direction.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/formatting/number_formatting.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 현재가와 전일 대비 등락을 크게 보여줍니다. 등락 방향 아이콘(▲/▼)이
/// 함께 붙습니다.
class PriceHero extends StatelessWidget {
  const PriceHero({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final PriceDirection direction = quote.direction;

    final Color color = switch (direction) {
      PriceDirection.up => colors.priceUpText,
      PriceDirection.down => colors.priceDownText,
      PriceDirection.flat => colors.priceFlatText,
    };

    // Icons.arrow_drop_up/down은 글리프 자체가 박스 안에서 위쪽/아래쪽에
    // 작게 그려져 있어 크기를 키워도 왜소해 보입니다. 실제 삼각형
    // 문자(▲/▼)를 써서 fontSize로 정확히 크기를 조절합니다.
    final String? arrowGlyph = switch (direction) {
      PriceDirection.up => '▲',
      PriceDirection.down => '▼',
      PriceDirection.flat => null,
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space2),
      child: Row(
        // 큰 가격 숫자와 작은 등락 배지의 밑선이 맞도록 아래쪽 정렬합니다.
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            NumberFormatting.comma(quote.currentPrice),
            style: TextStyle(color: colors.textPrimary, fontSize: 30, fontWeight: AppTypography.bold),
          ),
          SizedBox(width: dimens.space2),
          if (arrowGlyph != null) ...<Widget>[
            // 등락 텍스트와 같은 15px로 맞춥니다.
            Text(arrowGlyph, style: TextStyle(color: color, fontSize: 15)),
            SizedBox(width: dimens.space1),
          ],
          // 방향은 화살표 + 색상으로 이미 표시하고 있어서 등락액은 부호
          // 없이, 등락률은 부호를 유지해서 표시합니다.
          Text(
            NumberFormatting.changeLineAmountUnsigned(quote.changeAmount, quote.changeRate),
            style: TextStyle(color: color, fontSize: 15, fontWeight: AppTypography.medium),
          ),
        ],
      ),
    );
  }
}
