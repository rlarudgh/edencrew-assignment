import 'dart:convert';

import 'package:edencrew_assignment_starter/data/naver/daily_price_page_cache.dart';
import 'package:edencrew_assignment_starter/data/naver/dto/autocomplete_item.dart';
import 'package:edencrew_assignment_starter/data/naver/dto/realtime_quote.dart';
import 'package:edencrew_assignment_starter/data/naver/dto/stock_metadata.dart';
import 'package:edencrew_assignment_starter/data/naver/naver_client.dart';
import 'package:edencrew_assignment_starter/data/naver/sise_day_parser.dart';
import 'package:edencrew_assignment_starter/data/stock_repository.dart';
import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/market.dart';
import 'package:edencrew_assignment_starter/domain/models/period_option.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:http/http.dart' as http;

/// `docs/NAVER_API.md`의 4개 엔드포인트로 구현한 실제 데이터 저장소입니다.
///
/// 검색/관심/상세 화면 코드는 [StockRepository] 인터페이스만 알고 있어서,
/// `MockStockRepository`에서 이 클래스로 교체하는 데 `providers/
/// stock_repository_provider.dart` 한 줄만 바꾸면 됩니다.
class NaverStockRepository implements StockRepository {
  NaverStockRepository({NaverClient? client}) : _client = client ?? NaverClient();

  static const List<String> _defaultWatchlistSymbols = <String>[
    '005930', // 삼성전자
    '000660', // SK하이닉스
    '035720', // 카카오
    '247540', // 에코프로비엠
    '373220', // LG에너지솔루션
  ];

  final NaverClient _client;
  final DailyPricePageCache _dailyPriceCache = DailyPricePageCache();

  @override
  List<String> get defaultWatchlistSymbols => _defaultWatchlistSymbols;

  /// 종목명/종목코드로 종목을 검색합니다. (엔드포인트 1)
  ///
  /// 자동완성 응답에 이름/시장명이 이미 들어있어서, 결과마다 종목
  /// 메타데이터(엔드포인트 3)를 다시 호출하지 않습니다 — 검색 결과가
  /// N개면 N번 더 호출하는 셈이라 "필요한 만큼만 요청" 원칙에 어긋납니다.
  /// 엔드포인트 3은 심볼만 있고 이름/시장을 모르는 경우(관심 목록
  /// 부트스트랩)에만 씁니다.
  @override
  Future<List<Stock>> searchStocks(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) return const <Stock>[];

    final Uri uri = Uri.https('ac.stock.naver.com', '/ac', <String, String>{
      'q': trimmed,
      'target': 'stock,ipo,index,marketindicator',
    });
    final String body = await _client.getDecodedText(uri);
    final Map<String, dynamic> json = jsonDecode(body) as Map<String, dynamic>;
    final List<dynamic> items = json['items'] as List<dynamic>? ?? <dynamic>[];

    return items
        .map((dynamic item) => AutocompleteItem.fromJson(item as Map<String, dynamic>))
        .where((AutocompleteItem item) => item.isDomesticStock)
        .map(
          (AutocompleteItem item) =>
              Stock(symbol: item.code, name: item.name, market: Market.fromTypeCode(item.typeCode)),
        )
        .toList();
  }

  /// 여러 종목의 시세를 한 번에 조회합니다. (엔드포인트 2, 항상 배치 호출)
  @override
  Future<Map<String, Quote>> fetchQuotes(List<String> symbols) async {
    if (symbols.isEmpty) return const <String, Quote>{};

    final Uri uri = Uri.https('polling.finance.naver.com', '/api/realtime', <String, String>{
      'query': 'SERVICE_ITEM:${symbols.join(',')}',
    });
    final String body = await _client.getDecodedText(uri);
    final Map<String, dynamic> json = jsonDecode(body) as Map<String, dynamic>;

    final List<dynamic> areas =
        (json['result'] as Map<String, dynamic>?)?['areas'] as List<dynamic>? ?? <dynamic>[];
    if (areas.isEmpty) return const <String, Quote>{};
    final List<dynamic> datas =
        (areas.first as Map<String, dynamic>)['datas'] as List<dynamic>? ?? <dynamic>[];

    final Map<String, Quote> result = <String, Quote>{};
    for (final dynamic raw in datas) {
      final RealtimeQuoteDto dto = RealtimeQuoteDto.fromJson(raw as Map<String, dynamic>);
      if (dto.symbol.isEmpty) continue;
      result[dto.symbol] = Quote(
        currentPrice: dto.currentPrice,
        previousClose: dto.previousClose,
        open: dto.open,
        high: dto.high,
        low: dto.low,
        volume: dto.volume,
        marketCap: dto.marketCap,
      );
    }
    return result;
  }

  /// 종목코드로 이름/시장명을 조회합니다. (엔드포인트 3)
  @override
  Future<Stock> fetchStockInfo(String symbol) async {
    final Uri uri = Uri.https('stock.naver.com', '/api/securityFe/api/fchart/domestic/stock/$symbol');
    final String body = await _client.getDecodedText(uri);
    final StockMetadataDto dto = StockMetadataDto.fromJson(jsonDecode(body) as Map<String, dynamic>);

    return Stock(
      symbol: dto.symbolCode,
      name: dto.stockName,
      market: Market.fromLabel(dto.stockExchangeNameKor),
    );
  }

  /// 기간에 맞는 일별 시세를 조회합니다. (엔드포인트 4, 페이지 캐싱은
  /// [DailyPricePageCache] 참고)
  @override
  Future<List<CandlePoint>> fetchDailyPrices(String symbol, PeriodOption period) {
    return _dailyPriceCache.get(symbol, period, (int page) => _fetchSiseDayPage(symbol, page));
  }

  Future<({List<CandlePoint> candles, int lastPage})> _fetchSiseDayPage(String symbol, int page) async {
    final Uri uri = Uri.https('finance.naver.com', '/item/sise_day.naver', <String, String>{
      'code': symbol,
      'page': '$page',
    });
    // User-Agent 없이 호출하면 차단 페이지가 오는 걸 확인했어서, Referer도
    // 함께 붙여 정상 요청처럼 보이게 합니다.
    final http.Response response = await _client.get(
      uri,
      headers: <String, String>{'Referer': 'https://finance.naver.com/item/main.naver?code=$symbol'},
    );

    final SiseDayPage parsed = parseSiseDayPage(response.bodyBytes);
    return (candles: parsed.candles, lastPage: parsed.lastPage);
  }
}
