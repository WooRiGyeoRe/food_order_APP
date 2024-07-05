import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget?
      bottomNavigationBar; // 물음표 쓴 이유 => bottomNavigationBar 안 쓰는 곳도 있을테니
  final Widget? floatingActionButton;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ??
          Colors.white, // 물음표를 넣는 이유 => 만약 입력받지 않으면(null이면), 기본 색깔인 흰색을 적용
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  // 물음표 => null 가능
  AppBar? renderAppBar() {
    if (title == null) {
      return null; // title이 null이면 return 빈화면
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title!, // 느낌표 => 절대로 null이 될 수 없다
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
