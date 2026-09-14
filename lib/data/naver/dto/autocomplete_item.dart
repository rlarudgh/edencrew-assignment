import 'package:flutter/foundation.dart';

/// 엔드포인트 1(검색 자동완성) 응답의 `items[]` 원소입니다.
@immutable
class AutocompleteItem {
  const AutocompleteItem({
    required this.code,
    required this.name,
    required this.typeCode,
    required this.nationCode,
    required this.category,
  });

  factory AutocompleteItem.fromJson(Map<String, dynamic> json) {
    return AutocompleteItem(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      typeCode: json['typeCode'] as String? ?? '',
      nationCode: json['nationCode'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }

  final String code;
  final String name;
  final String typeCode;
  final String nationCode;
  final String category;

  /// 국내 주식(6자리 종목코드)만 통과시킵니다. `docs/NAVER_API.md`가 요구하는
  /// 필터입니다.
  bool get isDomesticStock =>
      category == 'stock' && nationCode == 'KOR' && RegExp(r'^\d{6}$').hasMatch(code);
}
