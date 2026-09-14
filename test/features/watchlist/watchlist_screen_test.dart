import 'package:edencrew_assignment_starter/domain/models/market.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/features/watchlist/view/watchlist_screen.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_stock_repository.dart';

const Stock _samsung = Stock(symbol: '005930', name: '삼성전자', market: Market.kospi);
const Stock _hynix = Stock(symbol: '000660', name: 'SK하이닉스', market: Market.kospi);
const Stock _kakao = Stock(symbol: '035720', name: '카카오', market: Market.kospi);

Future<void> _pumpWatchlist(WidgetTester tester, FakeStockRepository repository) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [stockRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(theme: AppTheme.dark, home: const WatchlistScreen()),
    ),
  );
  await tester.pump(); // 최초 프레임
  await tester.pump(); // 부트스트랩(microtask) 이후 프레임
  await tester.pump(); // 시세 배치 조회 이후 프레임
}

void main() {
  testWidgets('관심 종목이 없으면 빈 상태를 보여준다', (WidgetTester tester) async {
    final FakeStockRepository repository = FakeStockRepository();
    await _pumpWatchlist(tester, repository);

    expect(find.text('관심 종목이 없습니다'), findsOneWidget);
    expect(find.text('검색 탭에서 종목을 찾아\n별 아이콘을 눌러 추가해 주세요.'), findsOneWidget);
  });

  testWidgets('상승/하락/보합 세 가지 색상을 모두 올바르게 표시한다', (WidgetTester tester) async {
    final FakeStockRepository repository = FakeStockRepository(
      defaultWatchlistSymbols: <String>['005930', '000660', '035720'],
      stocksBySymbol: <String, Stock>{'005930': _samsung, '000660': _hynix, '035720': _kakao},
      quotesBySymbol: <String, Quote>{
        '005930': const Quote(
          currentPrice: 179700,
          previousClose: 180100,
          open: 179700,
          high: 179700,
          low: 179700,
          volume: 1,
          marketCap: 1,
        ), // 하락
        '000660': const Quote(
          currentPrice: 412500,
          previousClose: 403000,
          open: 412500,
          high: 412500,
          low: 412500,
          volume: 1,
          marketCap: 1,
        ), // 상승
        '035720': const Quote(
          currentPrice: 61300,
          previousClose: 61300,
          open: 61300,
          high: 61300,
          low: 61300,
          volume: 1,
          marketCap: 1,
        ), // 보합
      },
    );
    await _pumpWatchlist(tester, repository);

    final BuildContext context = tester.element(find.byType(WatchlistScreen));
    final AppColors colors = context.colors;

    Color? colorOfChangeText(String changeLineText) {
      final Finder finder = find.text(changeLineText);
      expect(finder, findsOneWidget, reason: '"$changeLineText" 텍스트를 찾지 못했다');
      return tester.widget<Text>(finder).style?.color;
    }

    // 삼성전자: -400 (-0.22%) → 하락(파랑)
    expect(colorOfChangeText('-400 (-0.22%)'), colors.priceDownText);
    // SK하이닉스: +9,500 (+2.36%) → 상승(빨강)
    expect(colorOfChangeText('+9,500 (+2.36%)'), colors.priceUpText);
    // 카카오: 0 (0.00%) → 보합
    expect(colorOfChangeText('0 (0.00%)'), colors.priceFlatText);
  });

  testWidgets('정렬 바텀시트로 정렬 기준을 바꾸면 목록 순서와 칩 라벨이 바뀐다', (WidgetTester tester) async {
    final FakeStockRepository repository = FakeStockRepository(
      defaultWatchlistSymbols: <String>['005930', '000660', '035720'],
      stocksBySymbol: <String, Stock>{'005930': _samsung, '000660': _hynix, '035720': _kakao},
      quotesBySymbol: <String, Quote>{
        '005930': const Quote(
          currentPrice: 100,
          previousClose: 100,
          open: 100,
          high: 100,
          low: 100,
          volume: 1,
          marketCap: 1,
        ),
        '000660': const Quote(
          currentPrice: 999999,
          previousClose: 100,
          open: 100,
          high: 100,
          low: 100,
          volume: 1,
          marketCap: 1,
        ),
        '035720': const Quote(
          currentPrice: 200,
          previousClose: 100,
          open: 100,
          high: 100,
          low: 100,
          volume: 1,
          marketCap: 1,
        ),
      },
    );
    await _pumpWatchlist(tester, repository);

    // 기본 정렬은 가나다순.
    expect(find.text('가나다순'), findsOneWidget);

    await tester.tap(find.text('가나다순'));
    await tester.pumpAndSettle();

    expect(find.text('정렬'), findsOneWidget);
    await tester.tap(find.text('현재가순'));
    await tester.pumpAndSettle();

    expect(find.text('현재가순'), findsOneWidget);

    // 현재가순으로 바뀌면 SK하이닉스(999999)가 맨 위에 와야 한다.
    final Iterable<Stock> order = tester
        .widgetList<Text>(find.byType(Text))
        .map((Text t) => t.data)
        .whereType<String>()
        .where((String s) => <String>['삼성전자', 'SK하이닉스', '카카오'].contains(s))
        .map((String name) => <String, Stock>{'삼성전자': _samsung, 'SK하이닉스': _hynix, '카카오': _kakao}[name]!);
    expect(order.first.symbol, '000660');
  });

  testWidgets('새로고침 버튼을 누르면 시세를 다시 조회한다', (WidgetTester tester) async {
    final FakeStockRepository repository = FakeStockRepository(
      defaultWatchlistSymbols: <String>['005930'],
      stocksBySymbol: <String, Stock>{'005930': _samsung},
      quotesBySymbol: <String, Quote>{
        '005930': const Quote(
          currentPrice: 100,
          previousClose: 100,
          open: 100,
          high: 100,
          low: 100,
          volume: 1,
          marketCap: 1,
        ),
      },
    );
    await _pumpWatchlist(tester, repository);

    final int callsBefore = repository.fetchQuotesCalls.length;
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    expect(repository.fetchQuotesCalls.length, greaterThan(callsBefore));
  });
}
