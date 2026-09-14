import 'package:edencrew_assignment_starter/features/search/view/search_screen.dart';
import 'package:edencrew_assignment_starter/features/watchlist/view/watchlist_screen.dart';
import 'package:edencrew_assignment_starter/shared/widgets/app_bottom_nav.dart';
import 'package:flutter/material.dart';

/// 관심/검색 탭을 담는 바깥 껍데기입니다.
///
/// 탭 인덱스는 이 위젯 밖에서 읽을 일이 없어서 Riverpod provider가
/// 아니라 평범한 위젯 상태로 둡니다. [IndexedStack]을 써서 탭을
/// 전환해도 스크롤 위치와 정렬 상태가 유지됩니다.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const <Widget>[WatchlistScreen(), SearchScreen()],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
