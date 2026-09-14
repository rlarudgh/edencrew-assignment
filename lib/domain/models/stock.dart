import 'package:flutter/foundation.dart';

import 'market.dart';

/// 종목의 정적 정보입니다. 시세([Quote](../quote.dart))와 분리해서 관리합니다.
///
/// 동일성은 종목코드만으로 판단합니다. 관심 등록 여부를 확인하거나
/// [Set]/[Map]의 키로 쓸 때 이름이 달라져도(예: 검색 결과 갱신) 같은
/// 종목으로 취급하기 위해서입니다.
@immutable
class Stock {
  const Stock({required this.symbol, required this.name, required this.market});

  /// 6자리 종목코드. (예: '005930')
  final String symbol;

  final String name;

  final Market market;

  /// `docs/NAVER_API.md`가 요구하는 canonical id입니다. 국내 주식만 다루는
  /// 우리 모델에서는 심볼 자체로도 충돌이 없지만(도메인 필터를 통과한
  /// 종목만 Stock으로 만들기 때문), 요구사항을 명시적으로 만족시키기 위해
  /// 별도 getter로 노출해 둡니다.
  String get canonicalId => 'domestic:$symbol';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Stock && other.symbol == symbol);

  @override
  int get hashCode => symbol.hashCode;

  @override
  String toString() => 'Stock($symbol, $name)';
}
