import 'package:edencrew_assignment_starter/domain/models/search_result_item.dart';
import 'package:edencrew_assignment_starter/shared/widgets/favorite_star_button.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 검색 결과 한 행입니다. 종목명 안에서 검색어와 일치하는 부분을
/// `searchHighlight` 색으로 강조합니다.
class SearchResultRow extends StatelessWidget {
  const SearchResultRow({super.key, required this.item, required this.query, required this.onTap});

  final SearchResultItem item;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
        padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space3),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _HighlightedName(name: item.stock.name, query: query, colors: colors),
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
            FavoriteStarButton(stock: item.stock),
          ],
        ),
      ),
    );
  }
}

class _HighlightedName extends StatelessWidget {
  const _HighlightedName({required this.name, required this.query, required this.colors});

  final String name;
  final String query;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final String trimmedQuery = query.trim();
    final int matchIndex = trimmedQuery.isEmpty ? -1 : name.indexOf(trimmedQuery);
    final TextStyle baseStyle = TextStyle(
      color: colors.textPrimary,
      fontSize: 16,
      fontWeight: AppTypography.bold,
    );

    if (matchIndex < 0) {
      return Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: baseStyle);
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: baseStyle,
        children: <TextSpan>[
          TextSpan(text: name.substring(0, matchIndex)),
          TextSpan(
            text: name.substring(matchIndex, matchIndex + trimmedQuery.length),
            style: TextStyle(color: colors.searchHighlight),
          ),
          TextSpan(text: name.substring(matchIndex + trimmedQuery.length)),
        ],
      ),
    );
  }
}
