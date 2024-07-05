import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_actual/common/component/custom_text_form_field.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/user/view/login_screen.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false, // 디버깅 모드 배너 끄기
      home: const LoginScreen(),
    );
  }
}
