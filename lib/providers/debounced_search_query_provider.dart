import 'dart:async';

import 'package:edencrew_assignment_starter/providers/search_query_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 검색 실행에 실제로 쓰이는(디바운스된) 검색어입니다.
///
/// [searchQueryProvider]는 입력창의 raw 텍스트라 매 키 입력마다 바뀌지만,
/// 이 provider는 그 값이 300ms 동안 더 안 바뀌었을 때만 반영됩니다.
/// `searchResultsProvider`와 검색 화면의 상태 분기는 이 값을 구독해서,
/// 타이핑 중에는 Naver 자동완성 API를 매번 호출하지 않습니다.
/// (`docs/NAVER_API.md`가 "호출이 잦으면 차단될 수 있다"고 경고하는
/// 부분에 대한 대응이자, 과제의 선택 항목인 "입력 디바운스 처리"입니다.)
///
/// 입력을 지울 때(빈 문자열)는 지연 없이 바로 반영합니다 — 검색 결과가
/// 잠깐 남아있다가 사라지는 것보다, 지우자마자 초기 상태로 돌아가는 게
/// 자연스럽습니다.
class DebouncedSearchQueryController extends Notifier<String> {
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  Timer? _timer;

  @override
  String build() {
    ref.listen<String>(searchQueryProvider, _onRawQueryChanged, fireImmediately: true);
    ref.onDispose(() => _timer?.cancel());
    return '';
  }

  void _onRawQueryChanged(String? previous, String next) {
    _timer?.cancel();

    if (next.trim().isEmpty) {
      state = next;
      return;
    }

    _timer = Timer(_debounceDuration, () => state = next);
  }
}

final NotifierProvider<DebouncedSearchQueryController, String> debouncedSearchQueryProvider =
    NotifierProvider<DebouncedSearchQueryController, String>(DebouncedSearchQueryController.new);
