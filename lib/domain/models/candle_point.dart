import 'package:flutter/foundation.dart';

/// 하루치 시세(캔들 하나)입니다. 차트와 일별 시세 표가 같은 데이터를 공유합니다.
@immutable
class CandlePoint {
  const CandlePoint({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  final DateTime date;
  final int open;
  final int high;
  final int low;
  final int close;
  final int volume;
}
