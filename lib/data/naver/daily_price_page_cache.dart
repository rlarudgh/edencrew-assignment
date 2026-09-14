import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/period_option.dart';

/// 한 페이지에 담기는 거래일 수. `docs/NAVER_API.md` 기준.
const int _candlesPerPage = 10;

/// 종목별 일별 시세 페이지 캐시입니다.
///
/// `docs/NAVER_API.md`의 "1년도 한 번에 전부 받지 말고 필요한 만큼만 받고
/// 이미 받은 페이지는 재사용" / "`lastPage`보다 큰 페이지를 요청하지 않는다"
/// 요구사항을 구현합니다. Riverpod과 무관한 순수 Dart 클래스로 둬서 단독
/// 테스트가 가능합니다.
class DailyPricePageCache {
  final Map<String, _SymbolCache> _bySymbol = <String, _SymbolCache>{};

  /// [period]가 필요로 하는 만큼의 캔들을 오래된→최신 순으로 반환합니다.
  ///
  /// [fetchPage]는 (페이지 번호) -> 해당 페이지의 파싱 결과를 반환하는
  /// 콜백입니다. 이미 캐시에 있는 페이지는 호출하지 않습니다.
  Future<List<CandlePoint>> get(
    String symbol,
    PeriodOption period,
    Future<({List<CandlePoint> candles, int lastPage})> Function(int page) fetchPage,
  ) async {
    final _SymbolCache cache = _bySymbol.putIfAbsent(symbol, _SymbolCache.new);
    int neededPages = (period.approxTradingDays / _candlesPerPage).ceil();
    if (cache.lastPage != null) {
      neededPages = neededPages.clamp(1, cache.lastPage!);
    }

    for (int page = 1; page <= neededPages; page++) {
      if (cache.pagesByNumber.containsKey(page)) continue;

      final ({List<CandlePoint> candles, int lastPage}) result = await fetchPage(page);
      cache.pagesByNumber[page] = result.candles;
      cache.lastPage = result.lastPage;
      // 첫 페이지를 받고 나서야 진짜 lastPage를 알 수 있으므로, 필요한
      // 페이지 수를 다시 한 번 clamp합니다.
      neededPages = neededPages.clamp(1, cache.lastPage!);
    }

    // 페이지 1(최신 10일)~neededPages(더 과거) 순으로 이어붙이면 페이지
    // 내부는 오름차순이지만 페이지 사이는 내림차순이라, 전체를 날짜
    // 기준으로 다시 정렬해 오름차순(오래된→최신)으로 맞춥니다.
    final List<CandlePoint> combined = <CandlePoint>[
      for (int page = 1; page <= neededPages; page++) ...?cache.pagesByNumber[page],
    ]..sort((CandlePoint a, CandlePoint b) => a.date.compareTo(b.date));

    final int take = period.approxTradingDays;
    return combined.length <= take ? combined : combined.sublist(combined.length - take);
  }
}

class _SymbolCache {
  final Map<int, List<CandlePoint>> pagesByNumber = <int, List<CandlePoint>>{};
  int? lastPage;
}
