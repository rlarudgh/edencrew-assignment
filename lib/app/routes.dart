import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/features/detail/view/detail_screen.dart';
import 'package:flutter/material.dart';

/// 종목상세 화면으로 이동합니다. 관심/검색 화면 모두 이 함수를
/// 통해서만 상세로 이동합니다.
void pushDetail(BuildContext context, Stock stock) {
  Navigator.of(
    context,
  ).push<void>(MaterialPageRoute<void>(builder: (BuildContext context) => DetailScreen(stock: stock)));
}
