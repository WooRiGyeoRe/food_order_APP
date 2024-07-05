import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/common/layout/default_layout.dart';
import 'package:flutter_actual/restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  // 탭 컨트롤러
  // late => 나중에 이 값이 입력될 건데, 이 값을 부를 때 이 컨트롤러라는 값이 이미 선언 돼 있을 거야 가정
  // TabController? 가능... 하지만 controller 쓸 때마다 null 처리해야 함
  late TabController controller;

  // 탭 저장
  int index = 0; // 처음에는 0

  @override
  void initState() {
    super.initState();

    // length = 몇개의 화면을 컨트롤할 건지
    // vsync에는 무조건 with SingleTickerProviderStateMixin 작성하고 현재 class를 작성
    controller = TabController(length: 4, vsync: this);

    // addListener => 값이 변경될 때마다 특정 변수를 실행해라
    controller.addListener(tabListener);
  }

  // 컨트롤러의 인덱스를 이 인덱스에다가 계속 넣어줌
  // 그리고 매번 이 컨트롤러에서 변화가 있을 때마다 setState를 실행
  // controller에서 매번 속성들이 바뀔 때마다 tabListener 함수가 실행됨
  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

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
            // this.index = index; // 선택할 때마다 this.index는 index로 저장
            controller.animateTo(index);
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
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          // Center(child: Container(child: const Text('홈'))),
          const RestaurantScreen(),
          Center(child: Container(child: const Text('음식'))),
          Center(child: Container(child: const Text('주문'))),
          Center(child: Container(child: const Text('프로필'))),
        ],
      ),
    );
  }
}
