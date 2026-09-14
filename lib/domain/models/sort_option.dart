/// 관심 목록 정렬 기준입니다. (`01 · 관심_sort` 프레임)
enum SortOption {
  priceDesc('현재가순'),
  changeRateDesc('등락률순'),
  nameAsc('가나다순');

  const SortOption(this.label);

  final String label;
}
