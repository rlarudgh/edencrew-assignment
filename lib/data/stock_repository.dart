import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/period_option.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';

/// 종목 데이터 소스 인터페이스입니다.
///
/// 지금은 [MockStockRepository](mock/mock_stock_repository.dart)만 존재하지만,
/// 나중에 Naver 연동 구현체(`data/naver/naver_stock_repository.dart`)로
/// 교체할 때 이 인터페이스만 지키면 화면 코드는 손대지 않아도 됩니다.
/// (교체 지점은 `providers/stock_repository_provider.dart` 한 곳뿐입니다.)
abstract interface class StockRepository {
  /// 종목명 또는 종목코드로 종목을 검색합니다.
  Future<List<Stock>> searchStocks(String query);

  /// 여러 종목의 시세를 한 번에 조회합니다.
  ///
  /// `docs/NAVER_API.md`의 "종목마다 따로 호출하지 않는다" 요구사항을
  /// 그대로 반영해, 항상 이 배치 형태로만 호출합니다.
  Future<Map<String, Quote>> fetchQuotes(List<String> symbols);

  /// 종목 하나의 기간별 일별 시세를 조회합니다.
  Future<List<CandlePoint>> fetchDailyPrices(String symbol, PeriodOption period);

  /// 종목코드로 이름/시장 같은 정적 정보를 조회합니다.
  ///
  /// 검색 결과는 자동완성 응답에 이름/시장이 이미 들어있어 이 메서드가
  /// 필요 없지만, 관심 목록을 심볼만으로 부트스트랩할 때는 이 메서드로
  /// 채웁니다. (검색 화면에서 다시 호출하지 않는 이유는
  /// `NaverStockRepository.searchStocks` 문서 주석 참고.)
  Future<Stock> fetchStockInfo(String symbol);

  /// 앱 시작 시 관심 목록에 기본으로 채워질 종목코드입니다.
  ///
  /// 이름/시장은 실제 API에서는 비동기로만 알 수 있어서 `Stock`이 아니라
  /// 심볼만 반환합니다 — [fetchStockInfo]로 채워 넣는 건 호출하는 쪽
  /// (`WatchlistController`)의 책임입니다.
  List<String> get defaultWatchlistSymbols;
}
