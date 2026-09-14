import 'package:edencrew_assignment_starter/domain/models/sort_option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 관심 목록 정렬 기준입니다. 관심 등록 여부와는 독립적인 화면 UI
/// 상태라서 [WatchlistController]와 분리했습니다.
class SortOptionController extends Notifier<SortOption> {
  @override
  SortOption build() => SortOption.nameAsc;

  void select(SortOption option) => state = option;
}

final NotifierProvider<SortOptionController, SortOption> sortOptionProvider =
    NotifierProvider<SortOptionController, SortOption>(SortOptionController.new);
