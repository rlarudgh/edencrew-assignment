import 'package:edencrew_assignment_starter/formatting/number_formatting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('comma', () {
    test('천 단위 구분 쉼표를 넣는다', () {
      expect(NumberFormatting.comma(179700), '179,700');
      expect(NumberFormatting.comma(0), '0');
    });
  });

  group('signedAmount', () {
    test('상승/하락/보합 부호를 붙인다', () {
      expect(NumberFormatting.signedAmount(9500), '+9,500');
      expect(NumberFormatting.signedAmount(-400), '-400');
      expect(NumberFormatting.signedAmount(0), '0');
    });
  });

  group('signedPercent', () {
    test('괄호 + 부호 + 퍼센트로 표시한다', () {
      expect(NumberFormatting.signedPercent(0.0236), '(+2.36%)');
      expect(NumberFormatting.signedPercent(-0.0022), '(-0.22%)');
      expect(NumberFormatting.signedPercent(0), '(0.00%)');
    });
  });

  group('changeLine', () {
    test('등락액과 등락률을 부호와 함께 한 줄로 합친다', () {
      expect(NumberFormatting.changeLine(-400, -0.0022), '-400 (-0.22%)');
      expect(NumberFormatting.changeLine(9500, 0.0236), '+9,500 (+2.36%)');
    });
  });

  group('changeLineAmountUnsigned', () {
    test('등락액은 부호 없이, 등락률은 부호를 유지한다', () {
      expect(NumberFormatting.changeLineAmountUnsigned(-9500, -0.0353), '9,500 (-3.53%)');
      expect(NumberFormatting.changeLineAmountUnsigned(9500, 0.0236), '9,500 (+2.36%)');
    });
  });

  group('volumeInThousands', () {
    test('거래량을 천 단위로 축약한다', () {
      expect(NumberFormatting.volumeInThousands(29113466), '29,113천');
    });
  });

  group('marketCapInTrillions', () {
    test('시가총액을 조 단위로 축약한다', () {
      expect(NumberFormatting.marketCapInTrillions(1063000000000000), '1,063조');
    });
  });

  group('monthDay', () {
    test('날짜를 MM.dd 형태로 표시한다', () {
      expect(NumberFormatting.monthDay(DateTime(2026, 9, 11)), '09.11');
    });
  });
}
