import 'package:edencrew_assignment_starter/data/naver/dto/autocomplete_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AutocompleteItem.isDomesticStock', () {
    test('국내 주식(6자리 코드 + KOR + stock 카테고리)만 통과시킨다', () {
      final AutocompleteItem item = AutocompleteItem.fromJson(<String, dynamic>{
        'code': '005930',
        'name': '삼성전자',
        'typeCode': 'KOSPI',
        'nationCode': 'KOR',
        'category': 'stock',
      });

      expect(item.isDomesticStock, isTrue);
    });

    test('해외 종목은 걸러낸다', () {
      final AutocompleteItem item = AutocompleteItem.fromJson(<String, dynamic>{
        'code': 'AAPL',
        'name': 'Apple',
        'typeCode': 'NASDAQ',
        'nationCode': 'USA',
        'category': 'stock',
      });

      expect(item.isDomesticStock, isFalse);
    });

    test('지수/시장지표 카테고리는 걸러낸다', () {
      final AutocompleteItem item = AutocompleteItem.fromJson(<String, dynamic>{
        'code': 'KOSPI',
        'name': '코스피',
        'typeCode': 'KOSPI',
        'nationCode': 'KOR',
        'category': 'index',
      });

      expect(item.isDomesticStock, isFalse);
    });

    test('6자리가 아닌 코드는 걸러낸다', () {
      final AutocompleteItem item = AutocompleteItem.fromJson(<String, dynamic>{
        'code': '5930',
        'name': '이상한코드',
        'typeCode': 'KOSPI',
        'nationCode': 'KOR',
        'category': 'stock',
      });

      expect(item.isDomesticStock, isFalse);
    });
  });
}
