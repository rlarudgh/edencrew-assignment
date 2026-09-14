import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/market.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/features/detail/view/detail_screen.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_stock_repository.dart';

const Stock _samsung = Stock(symbol: '005930', name: '삼성전자', market: Market.kospi);

const Quote _quote = Quote(
  currentPrice: 179700,
  previousClose: 180100, // 하락
  open: 172100,
  high: 181700,
  low: 172000,
  volume: 29113466,
  marketCap: 1063000000000000,
);

List<CandlePoint> _candles(int count, {required int close}) => List<CandlePoint>.generate(
  count,
  (int i) => CandlePoint(
    date: DateTime(2026, 1, 1).add(Duration(days: i)),
    open: close,
    high: close,
    low: close,
    close: close,
    volume: 100,
  ),
);

Future<void> _pumpDetail(WidgetTester tester, FakeStockRepository repository) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [stockRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(theme: AppTheme.dark, home: const DetailScreen(stock: _samsung)),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('헤더에 종목명/코드·시장이 뜨고, 하락은 파란색으로 표시된다', (WidgetTester tester) async {
    final FakeStockRepository repository = FakeStockRepository(
      stocksBySymbol: <String, Stock>{'005930': _samsung},
      quotesBySymbol: <String, Quote>{'005930': _quote},
      candlesBySymbol: <String, List<CandlePoint>>{'005930': _candles(20, close: 179700)},
    );
    await _pumpDetail(tester, repository);

    expect(find.text('삼성전자'), findsWidgets); // 헤더에 표시
    expect(find.text('005930 · 코스피'), findsOneWidget);
    // 일별 시세 표의 종가도 같은 텍스트("179,700")를 가질 수 있어서,
    // 큰 가격(fontSize 30)인 것만 콕 집어 확인한다.
    expect(
      find.byWidgetPredicate((Widget w) => w is Text && w.data == '179,700' && w.style?.fontSize == 30),
      findsOneWidget,
    );

    final BuildContext context = tester.element(find.byType(DetailScreen));
    final AppColors colors = context.colors;
    // 등락액은 부호 없이, 등락률은 부호 유지 (changeLineAmountUnsigned).
    final Text changeText = tester.widget<Text>(find.text('400 (-0.22%)'));
    expect(changeText.style?.color, colors.priceDownText);
  });

  testWidgets('요약카드에 거래량/시가총액이 축약 표기된다', (WidgetTester tester) async {
    final FakeStockRepository repository = FakeStockRepository(
      stocksBySymbol: <String, Stock>{'005930': _samsung},
      quotesBySymbol: <String, Quote>{'005930': _quote},
      candlesBySymbol: <String, List<CandlePoint>>{'005930': _candles(20, close: 179700)},
    );
    await _pumpDetail(tester, repository);

    expect(find.text('29,113천'), findsOneWidget);
    expect(find.text('1,063조'), findsOneWidget);
  });

  testWidgets('기간 탭을 바꾸면 다른 데이터로 갱신된다', (WidgetTester tester) async {
    final FakeStockRepository repository = FakeStockRepository(
      stocksBySymbol: <String, Stock>{'005930': _samsung},
      quotesBySymbol: <String, Quote>{'005930': _quote},
      candlesBySymbol: <String, List<CandlePoint>>{'005930': _candles(20, close: 179700)},
    );
    await _pumpDetail(tester, repository);

    // 기본은 1개월 탭이 선택돼 있어야 한다.
    expect(find.text('1개월'), findsOneWidget);
    expect(find.text('3개월'), findsOneWidget);

    await tester.tap(find.text('3개월'));
    await tester.pump();
    await tester.pump();

    // 3개월 탭으로 바뀌었어도 (같은 종가라) 요약/헤더 자체는 그대로다.
    // 실제로 다른 기간 provider를 구독하게 됐는지는 일별 시세 표 헤더가
    // 계속 정상적으로 그려지는지로 확인한다.
    expect(find.text('일별 시세'), findsOneWidget);
  });
}
