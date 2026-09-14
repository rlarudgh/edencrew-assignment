import 'package:edencrew_assignment_starter/data/stock_repository.dart';
import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/period_option.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';

/// 값과 호출 횟수를 완전히 통제할 수 있는 테스트 전용 [StockRepository]
/// 더블입니다.
///
/// `MockStockRepository`(`lib/data/mock/`)는 UI 개발용으로 고정된 시드
/// 데이터와 실제 지연 시간을 흉내 내는 용도라, 단위 테스트에서 정확한
/// 값을 주입하거나 호출 횟수를 세기엔 맞지 않습니다. 이 클래스가 그
/// 역할을 대신합니다.
class FakeStockRepository implements StockRepository {
  FakeStockRepository({
    List<String> defaultWatchlistSymbols = const <String>[],
    Map<String, Stock> stocksBySymbol = const <String, Stock>{},
    Map<String, Quote> quotesBySymbol = const <String, Quote>{},
    Map<String, List<Stock>> searchResultsByQuery = const <String, List<Stock>>{},
    Map<String, List<CandlePoint>> candlesBySymbol = const <String, List<CandlePoint>>{},
  }) : _defaultWatchlistSymbols = defaultWatchlistSymbols,
       _stocksBySymbol = Map<String, Stock>.of(stocksBySymbol),
       _quotesBySymbol = Map<String, Quote>.of(quotesBySymbol),
       _searchResultsByQuery = searchResultsByQuery,
       _candlesBySymbol = candlesBySymbol;

  final List<String> _defaultWatchlistSymbols;
  final Map<String, Stock> _stocksBySymbol;
  final Map<String, Quote> _quotesBySymbol;
  final Map<String, List<Stock>> _searchResultsByQuery;
  final Map<String, List<CandlePoint>> _candlesBySymbol;

  /// [fetchQuotes]에 실제로 넘어온 심볼 목록들. 배치 호출 검증용입니다.
  final List<List<String>> fetchQuotesCalls = <List<String>>[];

  /// [fetchStockInfo]가 호출된 횟수(심볼별).
  final List<String> fetchStockInfoCalls = <String>[];

  @override
  List<String> get defaultWatchlistSymbols => _defaultWatchlistSymbols;

  @override
  Future<Stock> fetchStockInfo(String symbol) async {
    fetchStockInfoCalls.add(symbol);
    final Stock? stock = _stocksBySymbol[symbol];
    if (stock == null) throw Exception('알 수 없는 종목코드: $symbol');
    return stock;
  }

  @override
  Future<List<Stock>> searchStocks(String query) async => _searchResultsByQuery[query] ?? const <Stock>[];

  @override
  Future<Map<String, Quote>> fetchQuotes(List<String> symbols) async {
    fetchQuotesCalls.add(symbols);
    return <String, Quote>{
      for (final String symbol in symbols)
        if (_quotesBySymbol.containsKey(symbol)) symbol: _quotesBySymbol[symbol]!,
    };
  }

  @override
  Future<List<CandlePoint>> fetchDailyPrices(String symbol, PeriodOption period) async =>
      _candlesBySymbol[symbol] ?? const <CandlePoint>[];

  /// 테스트 도중 시세를 갱신하고 싶을 때 씁니다. (예: refreshQuotes 이후
  /// 값이 바뀌는 시나리오)
  void setQuote(String symbol, Quote quote) => _quotesBySymbol[symbol] = quote;
}
