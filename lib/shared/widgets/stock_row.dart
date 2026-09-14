import 'package:edencrew_assignment_starter/domain/models/watchlist_item.dart';
import 'package:edencrew_assignment_starter/formatting/number_formatting.dart';
import 'package:edencrew_assignment_starter/shared/widgets/price_change_text.dart';
import 'package:edencrew_assignment_starter/shared/widgets/skeleton_box.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 관심 목록의 한 행입니다. 시세가 아직 없으면(quote == null) 스켈레톤을
/// 보여줍니다.
class StockRow extends StatelessWidget {
  const StockRow({super.key, required this.item, this.onTap});

  final WatchlistItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final quote = item.quote;

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
        padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    item.stock.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: AppTypography.bold),
                  ),
                  SizedBox(height: dimens.space1),
                  Text(
                    '${item.stock.symbol} · ${item.stock.market.label}',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 13,
                      fontWeight: AppTypography.regular,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: dimens.space3),
            if (quote == null)
              _SkeletonPriceBars(dimens: dimens)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    NumberFormatting.comma(quote.currentPrice),
                    style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: AppTypography.bold),
                  ),
                  SizedBox(height: dimens.space1),
                  PriceChangeText(changeAmount: quote.changeAmount, changeRate: quote.changeRate),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonPriceBars extends StatelessWidget {
  const _SkeletonPriceBars({required this.dimens});

  final AppDimens dimens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SkeletonBox(width: 64, height: 18),
        SizedBox(height: dimens.space1),
        const SkeletonBox(width: 88, height: 14),
      ],
    );
  }
}
