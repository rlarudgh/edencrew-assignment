import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 종목상세 화면이 쓰는 시세 provider입니다.
///
/// 이미 관심 목록에 있는 종목이면 [watchlistControllerProvider]가 들고
/// 있는 값을 그대로 재사용하고, 검색에서 막 들어와 관심 등록이 안 된
/// 종목만 별도로 조회합니다.
final detailQuoteProvider = FutureProvider.family<Quote?, String>((Ref ref, String symbol) async {
  final Quote? existing = ref.watch(watchlistControllerProvider).quotesBySymbol[symbol];
  if (existing != null) return existing;

  final Map<String, Quote> fetched = await ref.read(stockRepositoryProvider).fetchQuotes(<String>[symbol]);
  return fetched[symbol];
});
