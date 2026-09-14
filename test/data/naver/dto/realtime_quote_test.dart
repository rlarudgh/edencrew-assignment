import 'package:edencrew_assignment_starter/data/naver/dto/realtime_quote.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RealtimeQuoteDto', () {
    test('필드를 그대로 매핑한다', () {
      final RealtimeQuoteDto dto = RealtimeQuoteDto.fromJson(<String, dynamic>{
        'cd': '005930',
        'nv': 259500,
        'pcv': 269000,
        'ov': 258000,
        'hv': 261500,
        'lv': 256500,
        'aq': 13938673,
        'countOfListedStock': 5846278608,
      });

      expect(dto.symbol, '005930');
      expect(dto.currentPrice, 259500);
      expect(dto.previousClose, 269000);
      expect(dto.open, 258000);
      expect(dto.high, 261500);
      expect(dto.low, 256500);
      expect(dto.volume, 13938673);
    });

    test('시가총액은 현재가 × 상장주식수로 계산한다', () {
      final RealtimeQuoteDto dto = RealtimeQuoteDto.fromJson(<String, dynamic>{
        'cd': '005930',
        'nv': 100,
        'countOfListedStock': 5000,
      });

      expect(dto.marketCap, 500000);
    });
  });
}
