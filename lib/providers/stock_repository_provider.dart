import 'package:edencrew_assignment_starter/data/naver/naver_stock_repository.dart';
import 'package:edencrew_assignment_starter/data/stock_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱이 사용할 [StockRepository] 구현체입니다.
///
/// 실제 Naver 연동 구현체([NaverStockRepository])를 씁니다. 테스트에서는
/// 네트워크를 타지 않도록 `test/widget_test.dart`에서 `MockStockRepository`로
/// 오버라이드합니다 — 화면·provider 코드는 전혀 수정할 필요가 없습니다.
final Provider<StockRepository> stockRepositoryProvider = Provider<StockRepository>(
  (Ref ref) => NaverStockRepository(),
);
