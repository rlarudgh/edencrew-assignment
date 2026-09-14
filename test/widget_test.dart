import 'package:edencrew_assignment_starter/data/mock/mock_stock_repository.dart';
import 'package:edencrew_assignment_starter/main.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('홈 화면이 다크 테마의 관심/검색 탭으로 렌더링된다', (WidgetTester tester) async {
    // 실제 Naver 네트워크를 타지 않도록 mock으로 오버라이드합니다.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [stockRepositoryProvider.overrideWithValue(MockStockRepository())],
        child: const EdencrewAssignmentApp(),
      ),
    );
    // mock 시세 조회 지연(500ms)이 끝날 때까지 가상 시계를 진행시켜서,
    // 테스트 종료 시 타이머가 남아있다는 오류가 나지 않게 합니다.
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('관심'), findsWidgets);
    expect(find.text('검색'), findsWidgets);
    expect(Theme.of(tester.element(find.byType(Scaffold).first)).brightness, Brightness.dark);
  });
}
