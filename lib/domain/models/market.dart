/// 상장 시장 구분입니다. Figma의 `종목코드 · 시장` 표기에 그대로 쓰입니다.
enum Market {
  kospi('코스피'),
  kosdaq('코스닥');

  const Market(this.label);

  /// 화면에 표시할 한글 시장명입니다.
  final String label;

  /// 종목 메타데이터 엔드포인트의 `stockExchangeNameKor`(예: '코스피')를 변환합니다.
  static Market fromLabel(String label) =>
      values.firstWhere((Market market) => market.label == label, orElse: () => Market.kospi);

  /// 자동완성 엔드포인트의 `typeCode`(예: 'KOSPI')를 변환합니다.
  static Market fromTypeCode(String typeCode) => values.firstWhere(
    (Market market) => market.name == typeCode.toLowerCase(),
    orElse: () => Market.kospi,
  );
}
