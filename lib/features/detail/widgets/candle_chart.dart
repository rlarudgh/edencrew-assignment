import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 캔들 차트입니다. `CustomPainter`로 직접 그렸습니다.
///
/// 과제 요구사항상 캔들 두께/간격/여백/축 눈금 같은 렌더링 디테일은
/// 자유이고, 상승/하락 캔들 색상(`chartLineUp`/`chartLineDown`)만
/// 토큰과 일치하면 됩니다.
class CandleChart extends StatelessWidget {
  const CandleChart({super.key, required this.candles, this.height = 180});

  final List<CandlePoint> candles;
  final double height;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _CandleChartPainter(candles: candles, colors: colors)),
    );
  }
}

class _CandleChartPainter extends CustomPainter {
  _CandleChartPainter({required this.candles, required this.colors});

  final List<CandlePoint> candles;
  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final int highest = candles.map((CandlePoint c) => c.high).reduce((int a, int b) => a > b ? a : b);
    final int lowest = candles.map((CandlePoint c) => c.low).reduce((int a, int b) => a < b ? a : b);
    final double range = (highest - lowest).toDouble();
    if (range <= 0) return;

    final double slotWidth = size.width / candles.length;
    final double candleWidth = (slotWidth * 0.6).clamp(1.0, 12.0);

    double yFor(int value) => size.height - ((value - lowest) / range) * size.height;

    final Paint linePaint = Paint()..strokeWidth = 1;
    final Paint bodyPaint = Paint();

    for (int i = 0; i < candles.length; i++) {
      final CandlePoint candle = candles[i];
      final double centerX = slotWidth * i + slotWidth / 2;
      final bool isUp = candle.close >= candle.open;
      final Color color = isUp ? colors.chartLineUp : colors.chartLineDown;
      linePaint.color = color;
      bodyPaint.color = color;

      canvas.drawLine(Offset(centerX, yFor(candle.high)), Offset(centerX, yFor(candle.low)), linePaint);

      final double bodyTop = yFor(isUp ? candle.close : candle.open);
      final double bodyBottom = yFor(isUp ? candle.open : candle.close);
      final double bodyHeight = (bodyBottom - bodyTop).abs().clamp(1.0, double.infinity);

      canvas.drawRect(
        Rect.fromLTWH(centerX - candleWidth / 2, bodyTop, candleWidth, bodyHeight),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CandleChartPainter oldDelegate) => oldDelegate.candles != candles;
}
