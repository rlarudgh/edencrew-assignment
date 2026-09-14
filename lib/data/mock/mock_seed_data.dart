import 'dart:math';

import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/market.dart';
import 'package:edencrew_assignment_starter/domain/models/period_option.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';

/// 하드코딩된 mock 데이터입니다.
///
/// 실제 Naver 연동 전까지 화면 개발/검증에 사용합니다. 기본 관심 목록과
/// 시세 값은 과제 Figma 시안에 나온 숫자를 그대로 옮겼습니다.
abstract final class MockSeedData {
  /// 앱 시작 시 관심 목록에 기본으로 들어있는 종목입니다.
  static const List<Stock> defaultWatchlist = <Stock>[
    Stock(symbol: '005930', name: '삼성전자', market: Market.kospi),
    Stock(symbol: '000660', name: 'SK하이닉스', market: Market.kospi),
    Stock(symbol: '035720', name: '카카오', market: Market.kospi),
    Stock(symbol: '247540', name: '에코프로비엠', market: Market.kosdaq),
    Stock(symbol: '373220', name: 'LG에너지솔루션', market: Market.kospi),
  ];

  /// 검색에서만 노출되는 추가 종목입니다. 검색 화면에 결과가 있어야
  /// 하이라이트/빈 상태 등을 확인할 수 있어서 준비해 두었습니다.
  static const List<Stock> searchOnly = <Stock>[
    Stock(symbol: '005935', name: '삼성전자우', market: Market.kospi),
    Stock(symbol: '207940', name: '삼성바이오로직스', market: Market.kospi),
    Stock(symbol: '018260', name: '삼성에스디에스', market: Market.kospi),
    Stock(symbol: '010140', name: '삼성중공업', market: Market.kospi),
    Stock(symbol: '028260', name: '삼성물산', market: Market.kospi),
  ];

  static List<Stock> get allStocks => <Stock>[...defaultWatchlist, ...searchOnly];

  /// 종목코드별 현재 시세입니다. 관심 화면 시안(등락액/등락률)과 상세
  /// 화면 시안(시가/고가/저가/거래량/시가총액)의 숫자를 그대로 옮겼고,
  /// 시안에 없는 종목은 비슷한 규모로 임의 지정했습니다.
  static const Map<String, Quote> quotesBySymbol = <String, Quote>{
    '005930': Quote(
      currentPrice: 179700,
      previousClose: 180100,
      open: 172100,
      high: 181700,
      low: 172000,
      volume: 29113466,
      marketCap: 1063000000000000,
    ),
    '000660': Quote(
      currentPrice: 412500,
      previousClose: 403000,
      open: 405000,
      high: 415000,
      low: 402500,
      volume: 4123456,
      marketCap: 300000000000000,
    ),
    '035720': Quote(
      currentPrice: 61300,
      previousClose: 62100,
      open: 62000,
      high: 62400,
      low: 61000,
      volume: 3123456,
      marketCap: 27000000000000,
    ),
    '247540': Quote(
      currentPrice: 195400,
      previousClose: 195400,
      open: 195000,
      high: 197000,
      low: 194000,
      volume: 512345,
      marketCap: 19000000000000,
    ),
    '373220': Quote(
      currentPrice: 385000,
      previousClose: 388000,
      open: 387000,
      high: 390000,
      low: 384000,
      volume: 612345,
      marketCap: 90000000000000,
    ),
    '005935': Quote(
      currentPrice: 148900,
      previousClose: 148200,
      open: 148300,
      high: 149500,
      low: 147900,
      volume: 823456,
      marketCap: 12000000000000,
    ),
    '207940': Quote(
      currentPrice: 987000,
      previousClose: 992000,
      open: 990000,
      high: 995000,
      low: 985000,
      volume: 123456,
      marketCap: 70000000000000,
    ),
    '018260': Quote(
      currentPrice: 165500,
      previousClose: 164800,
      open: 165000,
      high: 166200,
      low: 164500,
      volume: 234567,
      marketCap: 12800000000000,
    ),
    '010140': Quote(
      currentPrice: 13200,
      previousClose: 13350,
      open: 13300,
      high: 13400,
      low: 13100,
      volume: 3456789,
      marketCap: 15000000000000,
    ),
    '028260': Quote(
      currentPrice: 118700,
      previousClose: 118700,
      open: 118500,
      high: 119200,
      low: 118000,
      volume: 456789,
      marketCap: 22000000000000,
    ),
  };

  /// 종목 + 기간을 시드로 하는 결정론적 캔들 데이터를 생성합니다.
  ///
  /// 같은 종목/기간 조합이면 항상 같은 모양의 차트가 나오도록
  /// [Random]의 시드를 종목코드/기간 해시로 고정합니다. 마지막(가장 최근)
  /// 캔들의 종가는 [quotesBySymbol]의 현재가와 항상 같게 맞춰서, 상세
  /// 화면 상단의 현재가와 차트 끝이 어긋나지 않도록 합니다.
  static List<CandlePoint> generateCandles(String symbol, PeriodOption period) {
    final Quote? quote = quotesBySymbol[symbol];
    final int latestClose = quote?.currentPrice ?? 50000;
    final int count = period.approxTradingDays;
    final Random random = Random(Object.hash(symbol, period));

    final double startPrice = latestClose * (0.85 + random.nextDouble() * 0.3);
    final List<DateTime> dates = List<DateTime>.generate(
      count,
      (int i) => _tradingDayBefore(DateTime.now(), count - 1 - i),
    );

    final List<CandlePoint> candles = <CandlePoint>[];
    int previousClose = startPrice.round();
    for (int i = 0; i < count; i++) {
      final double progress = count == 1 ? 1 : i / (count - 1);
      final double trend = startPrice + (latestClose - startPrice) * progress;
      final double noise = trend * (random.nextDouble() - 0.5) * 0.03;
      final int close = i == count - 1 ? latestClose : (trend + noise).round();
      final int open = previousClose;
      final int swing = max(1, (close.abs() * 0.006).round());
      final int high = max(open, close) + random.nextInt(swing + 1);
      final int low = max(1, min(open, close) - random.nextInt(swing + 1));
      final int volume = 300000 + random.nextInt(15000000);

      candles.add(
        CandlePoint(date: dates[i], open: open, high: high, low: low, close: close, volume: volume),
      );
      previousClose = close;
    }

    return candles;
  }

  static DateTime _tradingDayBefore(DateTime from, int tradingDaysAgo) {
    DateTime day = from;
    int remaining = tradingDaysAgo;
    while (remaining > 0) {
      day = day.subtract(const Duration(days: 1));
      if (day.weekday != DateTime.saturday && day.weekday != DateTime.sunday) {
        remaining--;
      }
    }
    return day;
  }
}
