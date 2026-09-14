import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/shared/widgets/favorite_star_button.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 종목상세 화면 헤더입니다. 뒤로 가기, 종목명/코드·시장, 관심 등록
/// 버튼으로 구성됩니다.
class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key, required this.stock});

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space2),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  stock.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: AppTypography.bold),
                ),
                Text(
                  '${stock.symbol} · ${stock.market.label}',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 12,
                    fontWeight: AppTypography.regular,
                  ),
                ),
              ],
            ),
          ),
          FavoriteStarButton(stock: stock),
        ],
      ),
    );
  }
}
