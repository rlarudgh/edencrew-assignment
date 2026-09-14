import 'package:edencrew_assignment_starter/domain/models/market.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/features/search/view/search_screen.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_stock_repository.dart';

const Stock _samsung = Stock(symbol: '005930', name: '삼성전자', market: Market.kospi);

Future<void> _pumpSearch(WidgetTester tester, FakeStockRepository repository) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [stockRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(theme: AppTheme.dark, home: const SearchScreen()),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('검색 전에는 초기 안내 상태를 보여준다', (WidgetTester tester) async {
    await _pumpSearch(tester, FakeStockRepository());

    expect(find.text('종목을 검색해 보세요'), findsOneWidget);
    expect(find.text('종목명 또는 종목코드 6자리로\n검색하실 수 있습니다.'), findsOneWidget);
  });

  testWidgets('검색 결과가 없으면 입력한 검색어가 들어간 안내를 보여준다', (WidgetTester tester) async {
    await _pumpSearch(tester, FakeStockRepository(searchResultsByQuery: const <String, List<Stock>>{}));

    await tester.enterText(find.byType(TextField), 'ㄱㄴㄷㄹ');
    await tester.pump(const Duration(milliseconds: 350)); // 디바운스
    await tester.pump(); // 조회(Future) 완료 반영

    expect(find.text('검색 결과가 없습니다'), findsOneWidget);
    expect(find.text("'ㄱㄴㄷㄹ'와\n일치하는 검색 결과를 찾지 못했습니다."), findsOneWidget);
  });

  testWidgets('별 아이콘을 누르면 즉시 관심 등록되고 토스트가 뜬다', (WidgetTester tester) async {
    await _pumpSearch(
      tester,
      FakeStockRepository(
        searchResultsByQuery: <String, List<Stock>>{
          '삼성': <Stock>[_samsung],
        },
      ),
    );

    await tester.enterText(find.byType(TextField), '삼성');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();

    // 검색어와 일치하는 이름은 RichText(하이라이트)로 렌더링되므로
    // findRichText를 켜서 찾는다.
    expect(find.text('삼성전자', findRichText: true), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsOneWidget);

    await tester.tap(find.byIcon(Icons.star_border));
    await tester.pump();

    expect(find.byIcon(Icons.star), findsWidgets); // 별 아이콘이 채워짐
    expect(find.text('관심이 등록되었습니다.'), findsOneWidget);

    // 토스트의 2초 타이머를 흘려보내서 테스트 종료 시 pending timer 오류가
    // 나지 않게 한다.
    await tester.pump(const Duration(seconds: 3));
  });
}
