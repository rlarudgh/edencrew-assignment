import 'dart:async';

import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 관심 등록/해제 토스트입니다.
///
/// `SnackBar`는 `Scaffold` 하단에 고정되고 연타 시 여러 개가 큐에 쌓여
/// 보이는 문제가 있어서, 직접 관리하는 [OverlayEntry] 하나만 항상
/// 최신 상태로 갱신하는 방식을 택했습니다. 노출 시간(2초)은 Figma에
/// 정의되어 있지 않은 값이라 임의로 정했습니다.
class ToastOverlay {
  ToastOverlay._();

  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(BuildContext context, {required bool isFavorite}) {
    _timer?.cancel();
    _entry?.remove();

    final OverlayState overlay = Overlay.of(context);
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    final OverlayEntry entry = OverlayEntry(
      builder: (BuildContext context) => _ToastPill(isFavorite: isFavorite, colors: colors, dimens: dimens),
    );

    _entry = entry;
    overlay.insert(entry);
    _timer = Timer(const Duration(seconds: 2), () {
      entry.remove();
      _entry = null;
    });
  }
}

class _ToastPill extends StatelessWidget {
  const _ToastPill({required this.isFavorite, required this.colors, required this.dimens});

  final bool isFavorite;
  final AppColors colors;
  final AppDimens dimens;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dimens.space5,
      right: dimens.space5,
      bottom: dimens.tabBarHeight + dimens.space4,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space3),
          decoration: BoxDecoration(
            color: colors.surfaceOverlay,
            borderRadius: BorderRadius.circular(dimens.radiusLg),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? colors.favoriteActive : colors.favoriteInactive,
                size: dimens.iconMd,
              ),
              SizedBox(width: dimens.space2),
              Flexible(
                child: Text(
                  isFavorite ? '관심이 등록되었습니다.' : '관심이 해제되었습니다.',
                  style: TextStyle(color: colors.textPrimary, fontSize: 14, fontWeight: AppTypography.medium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
