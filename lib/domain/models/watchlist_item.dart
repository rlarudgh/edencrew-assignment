import 'package:flutter/foundation.dart';

import 'quote.dart';
import 'stock.dart';

/// 관심 목록의 한 행입니다. [quote]가 null이면 시세를 아직 못 받은
/// 상태이며, 화면은 이때 스켈레톤(`feedbackSkeleton`)을 보여줍니다.
@immutable
class WatchlistItem {
  const WatchlistItem({required this.stock, this.quote});

  final Stock stock;
  final Quote? quote;
}
