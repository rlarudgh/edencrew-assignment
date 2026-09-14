import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/period_option.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [candleDataProvider]의 family key입니다. 이름 있는 필드로 접근하려면
/// 레코드 타입을 중괄호로 선언해야 합니다 — `(String, PeriodOption)`처럼
/// 괄호만 쓰면 위치 기반 레코드가 되어 `.$1`/`.$2`로만 접근할 수 있습니다.
typedef CandleQuery = ({String symbol, PeriodOption period});

/// 종목 + 기간 조합별 일별 시세입니다.
///
/// Riverpod family 캐싱 덕분에 같은 (종목, 기간) 조합을 다시 요청하면
/// 재조회 없이 캐시된 값을 반환합니다 — `docs/NAVER_API.md`가 요구하는
/// "이미 받은 페이지는 재사용" 요구사항을 실제 Naver 연동에서 구현할 때
/// 이 provider가 그 자리를 대신합니다. 화면(DetailScreen)은 그대로 두고
/// 안쪽 fetch 로직만 페이지 캐싱으로 바뀔 예정입니다.
final candleDataProvider = FutureProvider.family<List<CandlePoint>, CandleQuery>((Ref ref, CandleQuery args) {
  return ref.read(stockRepositoryProvider).fetchDailyPrices(args.symbol, args.period);
});
