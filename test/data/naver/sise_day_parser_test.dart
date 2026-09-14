import 'dart:typed_data';

import 'package:charset/charset.dart';
import 'package:edencrew_assignment_starter/data/naver/sise_day_parser.dart';
import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures/sise_day_005930_page1.dart';

/// [siseDay005930Page1Html]은 삼성전자(005930) 1페이지의 실제 응답을
/// 저장해 둔 샘플입니다. EUC-KR HTML 파싱이 과제에서 가장 손이 많이 가는
/// 부분이라 회귀를 막기 위해 테스트로 남겨둡니다.
///
/// 실제 응답은 EUC-KR 바이트라, 텍스트 픽스처를 [eucKr]로 다시
/// 인코딩해서 파서에 넘깁니다(파서가 기대하는 입력과 동일하게 맞추기
/// 위함).
void main() {
  test('sise_day HTML 한 페이지를 오래된→최신 순 캔들로 파싱한다', () {
    final Uint8List bytes = Uint8List.fromList(eucKr.encode(siseDay005930Page1Html));
    final SiseDayPage page = parseSiseDayPage(bytes);

    // 한 페이지는 10거래일입니다.
    expect(page.candles.length, 10);

    // 오래된 날짜가 먼저 오도록 정렬돼 있어야 합니다.
    for (int i = 1; i < page.candles.length; i++) {
      expect(page.candles[i].date.isAfter(page.candles[i - 1].date), isTrue);
    }

    final CandlePoint latest = page.candles.last;
    expect(latest.date, DateTime(2026, 9, 14));
    expect(latest.close, 253000);
    expect(latest.open, 249500);
    expect(latest.high, 253500);
    expect(latest.low, 249000);
    expect(latest.volume, 7569375);

    final CandlePoint oldest = page.candles.first;
    expect(oldest.date, DateTime(2026, 9, 1));
    expect(oldest.close, 261000);

    // 페이지네비게이션의 "맨뒤" 링크에서 뽑은 마지막 페이지.
    expect(page.lastPage, 756);
  });
}
