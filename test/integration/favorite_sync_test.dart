import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/market.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/features/detail/view/detail_screen.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/detail_header.dart';
import 'package:edencrew_assignment_starter/features/search/view/search_screen.dart';
import 'package:edencrew_assignment_starter/features/watchlist/view/watchlist_screen.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_stock_repository.dart';

const Stock _samsung = Stock(symbol: '005930', name: '삼성전자', market: Market.kospi);
const Quote _samsungQuote = Quote(
  currentPrice: 179700,
  previousClose: 180100,
  open: 172100,
  high: 181700,
  low: 172000,
  volume: 29113466,
  marketCap: 1063000000000000,
);
final List<CandlePoint> _candles = <CandlePoint>[
  CandlePoint(date: DateTime(2026, 1, 1), open: 179700, high: 179700, low: 179700, close: 179700, volume: 1),
];

/// 실제 앱은 화면을 이동(push/pop)해도 같은 [ProviderScope]가 계속
/// 살아있어서 상태가 공유된다. 이 테스트는 그걸 그대로 흉내 내려고,
/// 화면 전체를 한 트리에 욱여넣는 대신 하나의 [ProviderContainer]를
/// 계속 재사용하면서 [pumpWidget]으로 화면만 갈아끼운다 — 실제 내비게이션과
/// 같은 상태 공유를 검증하면서도 화면별 전체 뷰포트를 그대로 쓸 수 있다.
Future<ProviderContainer> _boot(WidgetTester tester, FakeStockRepository repository) async {
  final ProviderContainer container = ProviderContainer(
    overrides: [stockRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _showScreen(WidgetTester tester, ProviderContainer container, Widget screen) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: MaterialApp(theme: AppTheme.dark, home: screen)),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('검색에서 관심 등록하면 관심 목록과 상세 화면 별 아이콘에 즉시 반영된다', (WidgetTester tester) async {
    final FakeStockRepository repository = FakeStockRepository(
      defaultWatchlistSymbols: const <String>[], // 관심 목록은 비어서 시작
      stocksBySymbol: <String, Stock>{'005930': _samsung},
      quotesBySymbol: <String, Quote>{'005930': _samsungQuote},
      searchResultsByQuery: <String, List<Stock>>{
        '삼성': <Stock>[_samsung],
      },
      candlesBySymbol: <String, List<CandlePoint>>{'005930': _candles},
    );
    final ProviderContainer container = await _boot(tester, repository);

    // 1) 상세 화면: 아직 관심 등록 전이라 별이 비어있다.
    await _showScreen(tester, container, const DetailScreen(stock: _samsung));
    expect(
      find.descendant(of: find.byType(DetailHeader), matching: find.byIcon(Icons.star_border)),
      findsOneWidget,
    );

    // 2) 검색 화면으로 "이동"(같은 container 유지) -> 검색 -> 별 등록.
    await _showScreen(tester, container, const SearchScreen());
    await tester.enterText(find.byType(TextField), '삼성');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.star_border));
    await tester.pump();
    expect(find.text('관심이 등록되었습니다.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3)); // 토스트 타이머 정리

    // 3) 관심 화면으로 "이동" -> 방금 등록한 종목이 보여야 한다.
    await _showScreen(tester, container, const WatchlistScreen());
    expect(find.text('관심 종목이 없습니다'), findsNothing);
    expect(find.text('삼성전자'), findsWidgets);

    // 4) 상세 화면으로 다시 "이동" -> 별이 채워져 있어야 한다.
    await _showScreen(tester, container, const DetailScreen(stock: _samsung));
    expect(find.descendant(of: find.byType(DetailHeader), matching: find.byIcon(Icons.star)), findsOneWidget);
  });

  testWidgets('상세 화면에서 관심 해제하면 관심 목록에서 사라지고 검색 결과 별도 비워진다', (WidgetTester tester) async {
    final FakeStockRepository repository = FakeStockRepository(
      defaultWatchlistSymbols: const <String>['005930'], // 처음부터 관심 등록돼 있음
      stocksBySymbol: <String, Stock>{'005930': _samsung},
      quotesBySymbol: <String, Quote>{'005930': _samsungQuote},
      searchResultsByQuery: <String, List<Stock>>{
        '삼성': <Stock>[_samsung],
      },
      candlesBySymbol: <String, List<CandlePoint>>{'005930': _candles},
    );
    final ProviderContainer container = await _boot(tester, repository);

    // 1) 관심 화면: 이미 등록돼 있다.
    await _showScreen(tester, container, const WatchlistScreen());
    expect(find.text('삼성전자'), findsWidgets);

    // 2) 상세 화면에서 해제.
    await _showScreen(tester, container, const DetailScreen(stock: _samsung));
    expect(find.descendant(of: find.byType(DetailHeader), matching: find.byIcon(Icons.star)), findsOneWidget);
    await tester.tap(find.descendant(of: find.byType(DetailHeader), matching: find.byIcon(Icons.star)));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3)); // 토스트 타이머를 다음 화면으로 넘어가기 전에 정리

    // 3) 관심 화면: 목록에서 사라졌어야 한다.
    await _showScreen(tester, container, const WatchlistScreen());
    expect(find.text('관심 종목이 없습니다'), findsOneWidget);

    // 4) 검색 화면: 별이 다시 비어있어야 한다.
    await _showScreen(tester, container, const SearchScreen());
    await tester.enterText(find.byType(TextField), '삼성');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
    expect(find.byIcon(Icons.star_border), findsOneWidget);
  });
}
