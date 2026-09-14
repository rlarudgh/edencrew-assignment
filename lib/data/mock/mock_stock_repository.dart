import 'package:edencrew_assignment_starter/data/mock/mock_seed_data.dart';
import 'package:edencrew_assignment_starter/data/stock_repository.dart';
import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/period_option.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';

/// 화면 개발 단계에서 사용하는 가짜 데이터 저장소입니다.
///
/// 실제 네트워크 지연을 흉내 내기 위해 [Future.delayed]를 넣어서, 시세를
/// 아직 못 받은 행의 스켈레톤 같은 로딩 상태를 실제로 거치도록 했습니다.
class MockStockRepository implements StockRepository {
  static const Duration _searchDelay = Duration(milliseconds: 200);
  static const Duration _quoteDelay = Duration(milliseconds: 500);
  static const Duration _dailyPriceDelay = Duration(milliseconds: 400);
  static const Duration _stockInfoDelay = Duration(milliseconds: 150);

  @override
  List<String> get defaultWatchlistSymbols =>
      MockSeedData.defaultWatchlist.map((Stock stock) => stock.symbol).toList();

  @override
  Future<Stock> fetchStockInfo(String symbol) async {
    await Future<void>.delayed(_stockInfoDelay);
    return MockSeedData.allStocks.firstWhere(
      (Stock stock) => stock.symbol == symbol,
      orElse: () => throw Exception('알 수 없는 종목코드: $symbol'),
    );
  }

  @override
  Future<List<Stock>> searchStocks(String query) async {
    await Future<void>.delayed(_searchDelay);
    final String trimmed = query.trim();
    if (trimmed.isEmpty) return const <Stock>[];

    return MockSeedData.allStocks
        .where((Stock stock) => stock.name.contains(trimmed) || stock.symbol.contains(trimmed))
        .toList();
  }

  @override
  Future<Map<String, Quote>> fetchQuotes(List<String> symbols) async {
    await Future<void>.delayed(_quoteDelay);
    final Map<String, Quote> result = <String, Quote>{};
    for (final String symbol in symbols) {
      final Quote? quote = MockSeedData.quotesBySymbol[symbol];
      if (quote != null) {
        result[symbol] = quote;
      }
    }
    return result;
  }

  @override
  Future<List<CandlePoint>> fetchDailyPrices(String symbol, PeriodOption period) async {
    await Future<void>.delayed(_dailyPriceDelay);
    return MockSeedData.generateCandles(symbol, period);
  }
}
