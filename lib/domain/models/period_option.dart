/// 종목상세 화면의 기간 탭입니다.
enum PeriodOption {
  oneMonth('1개월', 20),
  threeMonths('3개월', 60),
  sixMonths('6개월', 120),
  oneYear('1년', 245);

  const PeriodOption(this.label, this.approxTradingDays);

  final String label;

  /// 대략적인 거래일 수. mock 데이터에서 캔들 개수를 정하는 데만 사용합니다.
  /// (실제 Naver 연동 시에는 `docs/NAVER_API.md`의 페이지 수 계산으로 대체됩니다.)
  final int approxTradingDays;
}
