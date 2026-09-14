import 'package:flutter/foundation.dart';

/// 엔드포인트 2(실시간 시세) `result.areas[0].datas[]` 원소입니다.
@immutable
class RealtimeQuoteDto {
  const RealtimeQuoteDto({
    required this.symbol,
    required this.currentPrice,
    required this.previousClose,
    required this.open,
    required this.high,
    required this.low,
    required this.volume,
    required this.listedStockCount,
  });

  factory RealtimeQuoteDto.fromJson(Map<String, dynamic> json) {
    return RealtimeQuoteDto(
      symbol: json['cd'] as String? ?? '',
      currentPrice: (json['nv'] as num?)?.toInt() ?? 0,
      previousClose: (json['pcv'] as num?)?.toInt() ?? 0,
      open: (json['ov'] as num?)?.toInt() ?? 0,
      high: (json['hv'] as num?)?.toInt() ?? 0,
      low: (json['lv'] as num?)?.toInt() ?? 0,
      volume: (json['aq'] as num?)?.toInt() ?? 0,
      listedStockCount: (json['countOfListedStock'] as num?)?.toInt() ?? 0,
    );
  }

  final String symbol;
  final int currentPrice;
  final int previousClose;
  final int open;
  final int high;
  final int low;

  /// 누적 거래량 (`aq`).
  final int volume;

  /// 상장 주식 수.
  final int listedStockCount;

  /// 시가총액 = 현재가 × 상장주식수. `docs/NAVER_API.md`의 계산식입니다.
  int get marketCap => currentPrice * listedStockCount;
}
