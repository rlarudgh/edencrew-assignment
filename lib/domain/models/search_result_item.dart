import 'package:flutter/foundation.dart';

import 'stock.dart';

/// 검색 결과 한 행입니다. 관심 등록 여부를 시세 조회와 별개로 함께 들고 있습니다.
@immutable
class SearchResultItem {
  const SearchResultItem({required this.stock, required this.isFavorite});

  final Stock stock;
  final bool isFavorite;
}
