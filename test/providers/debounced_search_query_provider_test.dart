import 'package:edencrew_assignment_starter/providers/debounced_search_query_provider.dart';
import 'package:edencrew_assignment_starter/providers/search_query_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('빠르게 연속 입력하면 마지막 값만, 300ms 후에 한 번 반영된다', () async {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    final List<String> debouncedValues = <String>[];
    container.listen<String>(debouncedSearchQueryProvider, (String? prev, String next) {
      debouncedValues.add(next);
    }, fireImmediately: true);

    container.read(searchQueryProvider.notifier).update('삼');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    container.read(searchQueryProvider.notifier).update('삼성');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    container.read(searchQueryProvider.notifier).update('삼성전');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    container.read(searchQueryProvider.notifier).update('삼성전자');

    // 디바운스 시간(300ms)이 지나기 전에는 아직 반영 안 된다.
    await Future<void>.delayed(const Duration(milliseconds: 150));
    expect(debouncedValues, <String>['']);

    // 디바운스 시간이 지나면 마지막 값만 한 번 반영된다.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    expect(debouncedValues, <String>['', '삼성전자']);
  });

  test('입력을 지우면 지연 없이 즉시 반영된다', () async {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    final List<String> debouncedValues = <String>[];
    container.listen<String>(debouncedSearchQueryProvider, (String? prev, String next) {
      debouncedValues.add(next);
    }, fireImmediately: true);

    container.read(searchQueryProvider.notifier).update('삼성');
    await Future<void>.delayed(const Duration(milliseconds: 350));
    expect(debouncedValues.last, '삼성');

    container.read(searchQueryProvider.notifier).clear();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(debouncedValues.last, '');
  });
}
