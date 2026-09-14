import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_controller.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_state.dart';
import 'package:edencrew_assignment_starter/shared/widgets/toast_overlay.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 관심 등록 토글 버튼입니다. 검색 결과 행과 상세 화면 헤더에서
/// 재사용하므로, 항상 같은 방식으로 [WatchlistController.toggleFavorite]
/// 하나만 호출합니다 — 화면마다 별도의 변경 경로를 두지 않기 위해서입니다.
class FavoriteStarButton extends ConsumerWidget {
  const FavoriteStarButton({super.key, required this.stock, this.size = 24});

  final Stock stock;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isFavorite = ref.watch(
      watchlistControllerProvider.select((WatchlistState state) => state.isFavorite(stock.symbol)),
    );
    final AppColors colors = context.colors;

    return IconButton(
      onPressed: () {
        final bool willBeFavorite = !isFavorite;
        ref.read(watchlistControllerProvider.notifier).toggleFavorite(stock);
        ToastOverlay.show(context, isFavorite: willBeFavorite);
      },
      icon: Icon(
        isFavorite ? Icons.star : Icons.star_border,
        color: isFavorite ? colors.favoriteActive : colors.favoriteInactive,
        size: size,
      ),
    );
  }
}
