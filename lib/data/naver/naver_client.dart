import 'dart:convert';

import 'package:charset/charset.dart';
import 'package:http/http.dart' as http;

/// Naver 엔드포인트 호출 공통 로직입니다.
///
/// - 브라우저 User-Agent를 고정으로 붙입니다. User-Agent 없이 호출하면
///   `sise_day` 같은 엔드포인트는 차단 페이지를 돌려줍니다. (직접 curl로
///   확인함.)
/// - 응답 인코딩은 절대 UTF-8이라고 가정하지 않고, `Content-Type` 헤더의
///   charset을 그대로 따릅니다 — 실시간 시세/일별 시세 엔드포인트는
///   EUC-KR이라 UTF-8로 디코딩하면 한글이 깨집니다.
class NaverClient {
  NaverClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _userAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0 Safari/537.36';

  /// 원본 응답을 그대로 돌려줍니다. HTML 파싱처럼 raw byte가 필요할 때
  /// 사용합니다.
  Future<http.Response> get(Uri uri, {Map<String, String>? headers}) async {
    final http.Response response = await _client.get(
      uri,
      headers: <String, String>{'User-Agent': _userAgent, ...?headers},
    );

    if (response.statusCode != 200) {
      throw NaverApiException('${uri.path} 요청 실패 (HTTP ${response.statusCode})');
    }

    return response;
  }

  /// 응답 헤더의 charset에 맞춰 디코딩한 텍스트를 돌려줍니다. JSON
  /// 엔드포인트에서 사용합니다.
  Future<String> getDecodedText(Uri uri, {Map<String, String>? headers}) async {
    final http.Response response = await get(uri, headers: headers);
    final String charsetName = _extractCharset(response.headers['content-type']) ?? 'utf-8';
    final Encoding encoding = Charset.getByName(charsetName) ?? utf8;
    return encoding.decode(response.bodyBytes);
  }

  String? _extractCharset(String? contentType) {
    if (contentType == null) return null;
    final RegExpMatch? match = RegExp('charset=([^;]+)', caseSensitive: false).firstMatch(contentType);
    return match?.group(1)?.trim();
  }

  void close() => _client.close();
}

/// Naver 응답 처리 중 발생한 오류입니다. 화면 쪽 `AsyncValue.error`로 그대로
/// 전달되어 기존 에러 UI(로딩/에러 분기)가 그대로 재사용됩니다.
class NaverApiException implements Exception {
  NaverApiException(this.message);

  final String message;

  @override
  String toString() => 'NaverApiException: $message';
}
