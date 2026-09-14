import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:flutter/foundation.dart';

/// [WatchlistController]가 들고 있는 상태입니다.
@immutable
class WatchlistState {
  const WatchlistState({
    this.stocksBySymbol = const <String, Stock>{},
    this.memberSymbols = const <String>[],
    this.quotesBySymbol = const <String, Quote?>{},
    this.isRefreshing = false,
  });

  /// 관심 등록 여부와 무관하게, 지금까지 화면에 등장한 모든 종목의 정적
  /// 정보입니다. 검색에서 관심 등록한 종목도 여기 들어와야 관심 화면에서
  /// 이름/시장을 그릴 수 있습니다.
  final Map<String, Stock> stocksBySymbol;

  /// 관심 등록된 종목코드입니다. 추가된 순서를 유지합니다.
  final List<String> memberSymbols;

  /// 종목코드별 시세입니다. 값이 null이면 아직 조회하지 못한 상태입니다.
  final Map<String, Quote?> quotesBySymbol;

  final bool isRefreshing;

  bool isFavorite(String symbol) => memberSymbols.contains(symbol);

  WatchlistState copyWith({
    Map<String, Stock>? stocksBySymbol,
    List<String>? memberSymbols,
    Map<String, Quote?>? quotesBySymbol,
    bool? isRefreshing,
  }) {
    return WatchlistState(
      stocksBySymbol: stocksBySymbol ?? this.stocksBySymbol,
      memberSymbols: memberSymbols ?? this.memberSymbols,
      quotesBySymbol: quotesBySymbol ?? this.quotesBySymbol,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
