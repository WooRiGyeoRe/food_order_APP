import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/common/layout/default_layout.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> {
  // 탭 저장
  int index = 0; // 처음에는 0

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '푸드 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: BOTTOM_NAVIBAR_COLOR,
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed, // .shifting

        // 클릭한 탭의 인덱스 숫자
        onTap: (int index) {
          setState(() {
            this.index = index; // 선택할 때마다 this.index는 index로 저장
          });
        },
        currentIndex: index, // 현재 선택된 인덱스 지정
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '프로필',
          ),
        ],
      ),
      child: const Center(
        child: Text('Root Tab'),
      ),
    );
  }
}
