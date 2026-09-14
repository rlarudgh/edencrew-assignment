import 'package:charset/charset.dart';
import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

/// `sise_day.naver` 한 페이지의 파싱 결과입니다.
@immutable
class SiseDayPage {
  const SiseDayPage({required this.candles, required this.lastPage});

  /// 오래된 날짜가 먼저 오도록 정렬된 캔들입니다. (실제 페이지는 최신이
  /// 위쪽 행이라 파싱 중에 뒤집습니다.)
  final List<CandlePoint> candles;

  /// 페이지네비게이션의 "맨뒤" 링크에서 뽑은 마지막 페이지 번호입니다.
  final int lastPage;
}

/// 일별 시세 HTML 한 페이지를 파싱합니다.
///
/// 응답이 EUC-KR이라 [bytes]를 그대로 UTF-8로 디코딩하면 한글이 깨지므로
/// [eucKr]로 직접 디코딩합니다.
///
/// 표의 각 데이터 행은 `<td>`가 정확히 7개(날짜·종가·전일비·시가·고가·저가·
/// 거래량)입니다. 헤더 행(`<th>`)과 여백 행(`<td colspan="7">` 1개)은 자연히
/// 걸러집니다. **전일비(2번째 인덱스) 셀은 쓰지 않습니다** — 우리 모델
/// (`DailyPriceRow.listFromCandles`)이 인접한 날짜의 종가 차이로 등락을
/// 다시 계산하므로, 부호 없는 전일비 텍스트와 아이콘 클래스를 굳이
/// 파싱할 필요가 없습니다.
SiseDayPage parseSiseDayPage(Uint8List bytes) {
  final String html = eucKr.decode(bytes);
  final dom.Document document = html_parser.parse(html);

  final List<CandlePoint> candlesNewestFirst = <CandlePoint>[];
  for (final dom.Element row in document.querySelectorAll('table.type2 tr')) {
    final List<dom.Element> cells = row.querySelectorAll('td');
    if (cells.length != 7) continue;

    final DateTime? date = _parseDate(cells[0].text.trim());
    final int? close = _parseNumber(cells[1].text);
    final int? open = _parseNumber(cells[3].text);
    final int? high = _parseNumber(cells[4].text);
    final int? low = _parseNumber(cells[5].text);
    final int? volume = _parseNumber(cells[6].text);

    if (date == null || close == null || open == null || high == null || low == null || volume == null) {
      continue;
    }

    candlesNewestFirst.add(
      CandlePoint(date: date, open: open, high: high, low: low, close: close, volume: volume),
    );
  }

  return SiseDayPage(candles: candlesNewestFirst.reversed.toList(), lastPage: _parseLastPage(document));
}

/// '2026.09.11' 형태의 날짜 텍스트를 파싱합니다.
DateTime? _parseDate(String text) {
  final List<String> parts = text.split('.');
  if (parts.length != 3) return null;
  final int? year = int.tryParse(parts[0]);
  final int? month = int.tryParse(parts[1]);
  final int? day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) return null;
  return DateTime(year, month, day);
}

int? _parseNumber(String text) {
  final String digitsOnly = text.replaceAll(RegExp('[^0-9-]'), '');
  return digitsOnly.isEmpty ? null : int.tryParse(digitsOnly);
}

/// 페이지네비게이션의 `<td class="pgRR"><a href="...page=N">맨뒤</a></td>`
/// 링크에서 마지막 페이지 번호를 뽑습니다. 못 찾으면 1페이지만 있다고
/// 취급합니다.
int _parseLastPage(dom.Document document) {
  final String? href = document.querySelector('.pgRR a')?.attributes['href'];
  if (href == null) return 1;
  final Match? match = RegExp(r'page=(\d+)').firstMatch(href);
  return match != null ? int.parse(match.group(1)!) : 1;
}
