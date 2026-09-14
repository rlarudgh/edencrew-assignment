import 'package:edencrew_assignment_starter/data/naver/daily_price_page_cache.dart';
import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/period_option.dart';
import 'package:flutter_test/flutter_test.dart';

CandlePoint _candle(DateTime date, int close) =>
    CandlePoint(date: date, open: close, high: close, low: close, close: close, volume: 1000);

/// 10일치 페이지 하나를 만듭니다. [pageIndex]가 클수록 더 과거 페이지입니다.
({List<CandlePoint> candles, int lastPage}) _page(int pageIndex, {int lastPage = 100}) {
  final DateTime latest = DateTime(2026, 9, 11).subtract(Duration(days: 10 * pageIndex));
  final List<CandlePoint> candles = List<CandlePoint>.generate(
    10,
    (int i) => _candle(latest.subtract(Duration(days: i)), 1000 - i),
  ).reversed.toList();
  return (candles: candles, lastPage: lastPage);
}

void main() {
  group('DailyPricePageCache', () {
    test('이미 받은 페이지는 다시 요청하지 않는다', () async {
      final DailyPricePageCache cache = DailyPricePageCache();
      final List<int> requestedPages = <int>[];

      Future<({List<CandlePoint> candles, int lastPage})> fetchPage(int page) async {
        requestedPages.add(page);
        return _page(page - 1);
      }

      // 1개월(20일) -> 2페이지 필요.
      await cache.get('005930', PeriodOption.oneMonth, fetchPage);
      expect(requestedPages, <int>[1, 2]);

      // 다시 1개월을 요청하면 전부 캐시 히트라 추가 요청이 없어야 한다.
      requestedPages.clear();
      final List<CandlePoint> again = await cache.get('005930', PeriodOption.oneMonth, fetchPage);
      expect(requestedPages, isEmpty);
      expect(again.length, 20);

      // 3개월(60일) -> 6페이지 필요. 이미 있는 1~2페이지는 재요청하지 않고
      // 3~6페이지만 새로 받아야 한다.
      final List<CandlePoint> threeMonths = await cache.get('005930', PeriodOption.threeMonths, fetchPage);
      expect(requestedPages, <int>[3, 4, 5, 6]);
      expect(threeMonths.length, 60);
    });

    test('종목이 다르면 캐시를 공유하지 않는다', () async {
      final DailyPricePageCache cache = DailyPricePageCache();
      final List<String> requestedSymbols = <String>[];

      await cache.get('005930', PeriodOption.oneMonth, (int page) async {
        requestedSymbols.add('005930');
        return _page(page - 1);
      });
      await cache.get('000660', PeriodOption.oneMonth, (int page) async {
        requestedSymbols.add('000660');
        return _page(page - 1);
      });

      expect(requestedSymbols.where((String s) => s == '005930').length, greaterThan(0));
      expect(requestedSymbols.where((String s) => s == '000660').length, greaterThan(0));
    });

    test('lastPage보다 큰 페이지는 요청하지 않는다', () async {
      final DailyPricePageCache cache = DailyPricePageCache();
      final List<int> requestedPages = <int>[];

      // lastPage가 1이라, 1년(25페이지 필요)을 요청해도 1페이지만 받아야 한다.
      final List<CandlePoint> result = await cache.get('005930', PeriodOption.oneYear, (int page) async {
        requestedPages.add(page);
        return _page(page - 1, lastPage: 1);
      });

      expect(requestedPages, <int>[1]);
      expect(result.length, 10);
    });
  });
}
