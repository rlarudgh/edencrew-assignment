import 'package:edencrew_assignment_starter/providers/search_query_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 검색 입력창입니다. 입력 내용을 지우는 버튼은 텍스트가 있을 때만
/// 나타납니다.
class SearchField extends ConsumerStatefulWidget {
  const SearchField({super.key});

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final String query = ref.watch(searchQueryProvider);

    // provider 쪽에서 지우기 등으로 값이 바뀌면 텍스트 필드도 맞춰줍니다.
    if (_controller.text != query) {
      _controller.value = _controller.value.copyWith(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }

    return Container(
      margin: EdgeInsets.all(dimens.space4),
      // 10px은 기존 space 스케일(8/12...)에 없는 이 컴포넌트만의 값이라
      // 토큰 없이 직접 지정합니다. (폰트 크기와 같은 이유로 예외 처리)
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(dimens.radiusMd),
        border: Border.all(color: colors.borderSubtle, width: dimens.borderHairline),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.search, color: colors.textTertiary, size: dimens.iconMd),
          SizedBox(width: dimens.space2),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (String value) => ref.read(searchQueryProvider.notifier).update(value),
              style: TextStyle(color: colors.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: '종목명 또는 종목코드',
                hintStyle: TextStyle(color: colors.textTertiary, fontSize: 15),
              ),
            ),
          ),
          if (query.isNotEmpty)
            GestureDetector(
              onTap: () => ref.read(searchQueryProvider.notifier).clear(),
              child: Icon(Icons.close, color: colors.textTertiary, size: dimens.iconSm),
            ),
        ],
      ),
    );
  }
}
