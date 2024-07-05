import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/common/layout/default_layout.dart';
import 'package:flutter_actual/common/view/root_tab.dart';
import 'package:flutter_actual/user/view/login_screen.dart';

// 앱에 처음 진입할 때 잠시 여러 정보들과 데이터를 긁어오면서
// 어떤 페이지로 보내줘야하는지 판단하는 기본 페이지

// StatefulWidget으로 변경 => 앱이 처음 실행됐을 때만 SplashScreen 실행
// 이때, 토큰 유무를 확인
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // 위젯이 처음 생성됐을 때 하고 싶은 작업들은 => initState()에!
  @override
  void initState() {
    super.initState();

    // deleteToken();
    checkToken(); // checkToken이 다 실행될 때까지 스플래시스크린 로딩 화면
  }

  // deleteToken
  void deleteToken() async {
    await storage.deleteAll();
  }

  // inintState에서는 await 불가능 => 해결방법은 함수를 하나 더 생성하기
  void checkToken() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = Dio();

    // error 처리
    try {
      final resp = await dio.post(
        'http://$ip/auth/token',

        // Options => Dio 패키지에서 들어오는 패키지
        // options: 파라미터 = 로그인에 필요한 데이터들
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ),
      );
      // 정상 로그인
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const RootTab(),
          ),
          (route) => false);
    } catch (e) {
      // 로그인 에러 발생 시
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false);
    }

    /*
    // 둘 중 하나라도 null일 경우 => LoginScreen
    if (refreshToken == null || accessToken == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false);  
    } else {
      // 아니라면(로그인을 이미 했고, 로그인이 되어 있는 상태) => RootTab
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const RootTab(),
          ),
          (route) => false);
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width, // 너비를 최단으로 하면 자동으로 좌우로 가운데 정렬
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 이미지 넣기
            Image.asset(
              'asset/img/logo/symbol.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const Text(
              'Food Order App',
              style: TextStyle(
                  fontFamily: 'NotoSans',
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
