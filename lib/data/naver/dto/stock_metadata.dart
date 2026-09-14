import 'package:flutter/foundation.dart';

/// 엔드포인트 3(종목 메타데이터) 응답입니다.
@immutable
class StockMetadataDto {
  const StockMetadataDto({
    required this.symbolCode,
    required this.stockName,
    required this.stockExchangeNameKor,
  });

  factory StockMetadataDto.fromJson(Map<String, dynamic> json) {
    return StockMetadataDto(
      symbolCode: json['symbolCode'] as String? ?? '',
      stockName: json['stockName'] as String? ?? '',
      stockExchangeNameKor: json['stockExchangeNameKor'] as String? ?? '',
    );
  }

  final String symbolCode;
  final String stockName;
  final String stockExchangeNameKor;
}
