/// 삼성전자(005930) 일별 시세 1페이지의 실제 응답을 UTF-8 텍스트로 저장해 둔
/// 픽스처입니다.
///
/// 원래는 `assets/mock/`의 `.html` 파일을 읽어서 테스트했지만, 그 파일이
/// 알 수 없는 이유로 두 번이나 디스크에서 사라져서(외부 도구가 정리하는
/// 것으로 추정) 테스트 코드 안에 직접 내장하는 방식으로 바꿨습니다.
/// 실제 응답은 EUC-KR 바이트라서, 테스트에서 `eucKr.encode()`로 다시
/// 인코딩한 뒤 파서에 넘겨야 합니다.
const String siseDay005930Page1Html = r'''
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Npay 증권</title>
</head>
<body>
<script language="JavaScript">
function mouseOver(obj){
  obj.style.backgroundColor="#f6f4e5";
}
function mouseOut(obj){
  obj.style.backgroundColor="#ffffff";
}
</script>
				<h4 class="tlline2"><strong><span class="red03">일별</span>시세</strong></h4>
				<table cellspacing="0" class="type2">
				<tr>
				<th>날짜</th>
				<th>종가</th>
				<th>전일비</th>
				<th>시가</th>
				<th>고가</th>
				<th>저가</th>
				<th>거래량</th>
				</tr>
				<tr>
				<td colspan="7" height="8"></td>
				</tr>
				<tr onMouseOver="mouseOver(this)" onMouseOut="mouseOut(this)">
				<td align="center"><span class="tah p10 gray03">2026.09.14</span></td>
				<td class="num"><span class="tah p11">253,000</span></td>
				<td class="num">
				<em class="bu_p bu_pdn"><span class="blind">하락</span></em><span class="tah p11 nv01">
				6,500
				</span>
			</td>
				<td class="num"><span class="tah p11">249,500</span></td>
				<td class="num"><span class="tah p11">253,500</span></td>
				<td class="num"><span class="tah p11">249,000</span></td>
				<td class="num"><span class="tah p11">7,569,375</span></td>
				</tr>
					<tr onMouseOver="mouseOver(this)" onMouseOut="mouseOut(this)">
					<td align="center"><span class="tah p10 gray03">2026.09.11</span></td>
					<td class="num"><span class="tah p11">259,500</span></td>
					<td class="num">
				<em class="bu_p bu_pdn"><span class="blind">하락</span></em><span class="tah p11 nv01">
				9,500
				</span>
			</td>
					<td class="num"><span class="tah p11">258,000</span></td>
					<td class="num"><span class="tah p11">261,500</span></td>
					<td class="num"><span class="tah p11">256,500</span></td>
					<td class="num"><span class="tah p11">13,939,111</span></td>
					</tr>
					<tr onMouseOver="mouseOver(this)" onMouseOut="mouseOut(this)">
					<td align="center"><span class="tah p10 gray03">2026.09.10</span></td>
					<td class="num"><span class="tah p11">269,000</span></td>
					<td class="num">
				<em class="bu_p bu_pdn"><span class="blind">하락</span></em><span class="tah p11 nv01">
				500
				</span>
			</td>
					<td class="num"><span class="tah p11">269,000</span></td>
					<td class="num"><span class="tah p11">270,500</span></td>
					<td class="num"><span class="tah p11">263,500</span></td>
					<td class="num"><span class="tah p11">22,517,075</span></td>
					</tr>
					<tr onMouseOver="mouseOver(this)" onMouseOut="mouseOut(this)">
					<td align="center"><span class="tah p10 gray03">2026.09.09</span></td>
					<td class="num"><span class="tah p11">269,500</span></td>
					<td class="num">
				<em class="bu_p bu_pn"><span class="blind">보합</span></em><span class="tah p11">0</span>
			</td>
					<td class="num"><span class="tah p11">269,500</span></td>
					<td class="num"><span class="tah p11">275,000</span></td>
					<td class="num"><span class="tah p11">267,500</span></td>
					<td class="num"><span class="tah p11">16,370,962</span></td>
					</tr>
					<tr onMouseOver="mouseOver(this)" onMouseOut="mouseOut(this)">
					<td align="center"><span class="tah p10 gray03">2026.09.08</span></td>
					<td class="num"><span class="tah p11">269,500</span></td>
					<td class="num">
				<em class="bu_p bu_pdn"><span class="blind">하락</span></em><span class="tah p11 nv01">
				500
				</span>
			</td>
					<td class="num"><span class="tah p11">272,000</span></td>
					<td class="num"><span class="tah p11">279,000</span></td>
					<td class="num"><span class="tah p11">269,000</span></td>
					<td class="num"><span class="tah p11">22,716,517</span></td>
					</tr>
				<tr>
				<td colspan="7" height="8"></td>
				</tr>
				<tr>
				<td colspan="7" height="1" bgcolor="#e1e1e1"></td>
				</tr>
				<tr>
				<td colspan="7" height="8"></td>
				</tr>
					<tr onMouseOver="mouseOver(this)" onMouseOut="mouseOut(this)">
					<td align="center"><span class="tah p10 gray03">2026.09.07</span></td>
					<td class="num"><span class="tah p11">270,000</span></td>
					<td class="num">
				<em class="bu_p bu_pup"><span class="blind">상승</span></em><span class="tah p11 red02">
				14,500
				</span>
			</td>
					<td class="num"><span class="tah p11">267,000</span></td>
					<td class="num"><span class="tah p11">270,000</span></td>
					<td class="num"><span class="tah p11">264,000</span></td>
					<td class="num"><span class="tah p11">18,314,016</span></td>
					</tr>
					<tr onMouseOver="mouseOver(this)" onMouseOut="mouseOut(this)">
					<td align="center"><span class="tah p10 gray03">2026.09.04</span></td>
					<td class="num"><span class="tah p11">255,500</span></td>
					<td class="num">
				<em class="bu_p bu_pup"><span class="blind">상승</span></em><span class="tah p11 red02">
				5,500
				</span>
			</td>
					<td class="num"><span class="tah p11">254,000</span></td>
					<td class="num"><span class="tah p11">259,000</span></td>
					<td class="num"><span class="tah p11">252,500</span></td>
					<td class="num"><span class="tah p11">14,031,862</span></td>
					</tr>
					<tr onMouseOver="mouseOver(this)" onMouseOut="mouseOut(this)">
					<td align="center"><span class="tah p10 gray03">2026.09.03</span></td>
					<td class="num"><span class="tah p11">250,000</span></td>
					<td class="num">
				<em class="bu_p bu_pdn"><span class="blind">하락</span></em><span class="tah p11 nv01">
				500
				</span>
			</td>
					<td class="num"><span class="tah p11">254,000</span></td>
					<td class="num"><span class="tah p11">255,000</span></td>
					<td class="num"><span class="tah p11">243,000</span></td>
					<td class="num"><span class="tah p11">13,756,022</span></td>
					</tr>
					<tr onMouseOver="mouseOver(this)" onMouseOut="mouseOut(this)">
					<td align="center"><span class="tah p10 gray03">2026.09.02</span></td>
					<td class="num"><span class="tah p11">250,500</span></td>
					<td class="num">
				<em class="bu_p bu_pdn"><span class="blind">하락</span></em><span class="tah p11 nv01">
				10,500
				</span>
			</td>
					<td class="num"><span class="tah p11">252,000</span></td>
					<td class="num"><span class="tah p11">255,500</span></td>
					<td class="num"><span class="tah p11">249,500</span></td>
					<td class="num"><span class="tah p11">15,176,841</span></td>
					</tr>
					<tr onMouseOver="mouseOver(this)" onMouseOut="mouseOut(this)">
					<td align="center"><span class="tah p10 gray03">2026.09.01</span></td>
					<td class="num"><span class="tah p11">261,000</span></td>
					<td class="num">
				<em class="bu_p bu_pup"><span class="blind">상승</span></em><span class="tah p11 red02">
				1,000
				</span>
			</td>
					<td class="num"><span class="tah p11">256,500</span></td>
					<td class="num"><span class="tah p11">262,500</span></td>
					<td class="num"><span class="tah p11">254,000</span></td>
					<td class="num"><span class="tah p11">15,319,615</span></td>
					</tr>
				<tr>
				<td colspan="7" height="8"></td>
				</tr>
				</table>
				<table summary="페이지 네비게이션 리스트" class="Nnavi" align="center">
				<caption>페이지 네비게이션</caption>
				<tr>
                <td class="on">
				<a href="/item/sise_day.naver?code=005930&amp;page=1"  >1</a>
				</td>
<td>
				<a href="/item/sise_day.naver?code=005930&amp;page=2"  >2</a>
				</td>
                <td class="pgRR">
				<a href="/item/sise_day.naver?code=005930&amp;page=756"  >맨뒤
				<img src="https://ssl.pstatic.net/static/n/cmn/bu_pgarRR.gif" width="8" height="5" alt="" border="0">
				</a>
				</td>
				</tr>
				</table>
</body>
</html>
''';
