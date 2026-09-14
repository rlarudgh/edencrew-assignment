import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 검색창에 입력된 검색어입니다.
class SearchQueryController extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;

  void clear() => state = '';
}

final NotifierProvider<SearchQueryController, String> searchQueryProvider =
    NotifierProvider<SearchQueryController, String>(SearchQueryController.new);
