import 'package:flutter/foundation.dart';

import 'price_direction.dart';

/// 특정 시점의 시세 스냅샷입니다.
///
/// 등락액/등락률은 저장하지 않고 항상 [currentPrice]/[previousClose]에서
/// 계산합니다. `docs/NAVER_API.md`의 계산식(`nv - pcv`, `(nv - pcv) / pcv`)과
/// 동일합니다.
@immutable
class Quote {
  const Quote({
    required this.currentPrice,
    required this.previousClose,
    required this.open,
    required this.high,
    required this.low,
    required this.volume,
    required this.marketCap,
  });

  final int currentPrice;
  final int previousClose;
  final int open;
  final int high;
  final int low;

  /// 누적 거래량 (주).
  final int volume;

  /// 시가총액 (원).
  final int marketCap;

  /// 전일 대비 등락액.
  int get changeAmount => currentPrice - previousClose;

  /// 전일 대비 등락률. (0.0224 = +2.24%)
  double get changeRate => previousClose == 0 ? 0 : changeAmount / previousClose;

  PriceDirection get direction {
    if (changeAmount > 0) return PriceDirection.up;
    if (changeAmount < 0) return PriceDirection.down;
    return PriceDirection.flat;
  }
}
