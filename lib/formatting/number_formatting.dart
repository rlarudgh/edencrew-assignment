import 'package:intl/intl.dart';

/// 화면 전역에서 쓰는 숫자·날짜 포맷팅 함수 모음입니다.
///
/// 위젯에서 [NumberFormat]/[DateFormat]을 직접 만들어 쓰지 말고 항상 이
/// 클래스를 통해서만 포맷팅해 주세요. 규칙이 한 곳에 모여 있어야 표기
/// 형식이 화면마다 어긋나지 않습니다.
abstract final class NumberFormatting {
  static final NumberFormat _comma = NumberFormat('#,###');
  static final DateFormat _monthDay = DateFormat('MM.dd');

  /// 천 단위 구분 쉼표를 넣습니다. 예: 179700 -> '179,700'
  static String comma(num value) => _comma.format(value);

  /// 등락액을 부호와 함께 표시합니다. 보합(0)은 부호를 붙이지 않습니다.
  /// 예: +9,500 / -400 / 0
  static String signedAmount(int amount) {
    if (amount > 0) return '+${comma(amount)}';
    if (amount < 0) return '-${comma(amount.abs())}';
    return '0';
  }

  /// 등락률을 괄호 + 부호 + 퍼센트로 표시합니다.
  /// 예: (+2.36%) / (-0.22%) / (0.00%)
  static String signedPercent(double rate) {
    final double percent = rate * 100;
    final String sign = percent > 0
        ? '+'
        : percent < 0
        ? '-'
        : '';
    return '($sign${percent.abs().toStringAsFixed(2)}%)';
  }

  /// 등락액 + 등락률을 한 줄로 합칩니다. 예: -400 (-0.22%)
  static String changeLine(int amount, double rate) => '${signedAmount(amount)} ${signedPercent(rate)}';

  /// 등락액은 부호 없이, 등락률은 부호와 함께 한 줄로 합칩니다.
  /// 예: 9,500 (+2.36%)
  /// 화살표(▲/▼)와 색상으로 이미 방향을 표시하는 종목상세 큰 가격
  /// 영역(`PriceHero`)에서, 등락액까지 부호를 넣으면 중복돼 보여 등락액만
  /// 부호를 뺍니다. 관심 목록 행/일별 시세 표는 부호를 유지해야 하므로
  /// [changeLine]을 그대로 씁니다.
  static String changeLineAmountUnsigned(int amount, double rate) =>
      '${comma(amount.abs())} ${signedPercent(rate)}';

  /// 거래량을 천 단위로 축약합니다. 예: 29113466 -> '29,113천'
  static String volumeInThousands(int volume) => '${comma((volume / 1000).round())}천';

  /// 시가총액을 조 단위로 축약합니다. 예: 1063000000000000 -> '1,063조'
  static String marketCapInTrillions(int marketCapWon) =>
      '${comma((marketCapWon / 1000000000000).round())}조';

  /// 날짜를 MM.DD 형태로 표시합니다.
  static String monthDay(DateTime date) => _monthDay.format(date);
}
