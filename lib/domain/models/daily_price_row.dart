import 'package:flutter/foundation.dart';

import 'candle_point.dart';
import 'price_direction.dart';

/// 일별 시세 표 한 행입니다. 전일 종가 대비 등락을 미리 계산해 둡니다.
@immutable
class DailyPriceRow {
  const DailyPriceRow({
    required this.date,
    required this.close,
    required this.changeAmount,
    required this.volume,
  });

  factory DailyPriceRow.fromCandle({
    required CandlePoint candle,
    required int previousClose,
  }) {
    return DailyPriceRow(
      date: candle.date,
      close: candle.close,
      changeAmount: candle.close - previousClose,
      volume: candle.volume,
    );
  }

  /// 오래된 날짜가 먼저 오는 [candlesAscending]으로부터 표에 그대로 뿌릴 수
  /// 있는 최신순(내림차순) 목록을 만듭니다. 가장 오래된 행의 "전일 종가"는
  /// 해당 날짜의 시가로 근사합니다 — 조회 범위 밖의 데이터라 정확한 전일
  /// 종가를 알 수 없기 때문입니다.
  static List<DailyPriceRow> listFromCandles(List<CandlePoint> candlesAscending) {
    final List<DailyPriceRow> rows = <DailyPriceRow>[];
    for (int i = 0; i < candlesAscending.length; i++) {
      final CandlePoint candle = candlesAscending[i];
      final int previousClose = i == 0 ? candle.open : candlesAscending[i - 1].close;
      rows.add(DailyPriceRow.fromCandle(candle: candle, previousClose: previousClose));
    }
    return rows.reversed.toList();
  }

  final DateTime date;
  final int close;
  final int changeAmount;
  final int volume;

  PriceDirection get direction {
    if (changeAmount > 0) return PriceDirection.up;
    if (changeAmount < 0) return PriceDirection.down;
    return PriceDirection.flat;
  }
}
