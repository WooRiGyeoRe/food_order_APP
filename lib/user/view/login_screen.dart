import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_actual/common/component/custom_text_form_field.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/common/layout/default_layout.dart';
import 'package:flutter_actual/common/view/root_tab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// build 다시 실행할 수도 있으니까 StatefulWidget로 변경해주기
// showcontextaction VS Code에서는 안되나… ???
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    // Dio => api통신을 할 때 필요한 라이브러리
    // Dio 여러 번 사용하려고 위에다 사용
    final dio = Dio();

    // flutter_secure_storage 열기
    const storage = FlutterSecureStorage();

    // 기본 아이피 == localhost
    // final emulatorIp = '10.0.2.2:(port)';
    // final simulatorIp = '127.0.0.1:(port)';
    const emulatorIp = '10.0.2.2:3000';
    const simulatorIp = '127.0.0.1:3000';

    // isIOS라면 simulatorIp를 반환하고
    // 아닐 경우에는 emulatorIp를 반환
    final ip = Platform.isIOS ? simulatorIp : emulatorIp;

    return DefaultLayout(
        child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Title(),
              const SizedBox(height: 16),
              const _SubTitle(),
              Image.asset(
                'asset/img/misc/logo.png',
                width: MediaQuery.of(context).size.width / 3 * 2,
              ),
              CustomTextFormField(
                hintText: '이메일을 입력해주세요.',
                // onChanged -> TextField에 값이 들어갈 때마다 (String? value) {  } 콜백이 불림
                // 여기서 value는 실제 입력한 값
                onChanged: (String? value) {
                  username = value!;
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: '비밀번호를 입력해주세요.',
                onChanged: (String? value) {
                  password = value!;
                },
                obscureText: true,
                //errorText: '에러가 발생했습니다.',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                // async , await => 비동기
                onPressed: () async {
                  // ID : 비밀번호
                  //const rawString = 'test@codefactory.ai:testtest';
                  final rawString = '$username:$password';

                  print(rawString);

                  // base64 encode 작업 ---------> 그냥 외워서 사용하자!
                  // <String 값을 넣고, String 값을 반환 받겠다>
                  Codec<String, String> stringToBase64 =
                      utf8.fuse(base64); // 정의

                  // rawString라는 String 값을 stringToBase64로 인코딩해서 token에 담기
                  String token = stringToBase64.encode(rawString);
                  print(
                      token); // 'test@codefactory.ai:testtest'이게 아니라 인코딩된 값으로 보일거임!!!

                  // post(path) => 경로
                  // 로그인 버튼 누를 때마다 login api로 요청을 보냄
                  // 응답을 받는 곳 => resp
                  final resp = await dio.post(
                    'http://$ip/auth/login',

                    // Options => Dio 패키지에서 들어오는 패키지
                    // options: 파라미터 = 로그인에 필요한 데이터들
                    options: Options(
                      headers: {
                        'authorization': 'Basic $token',
                      },
                    ),
                  );
                  final refreshToken = resp.data['refreshToken'];
                  final accessToken = resp.data['accessToken'];

                  // .write => 스토리지 안에 값 넣어 쓰기
                  await storage.write(
                      key: REFRESH_TOKEN_KEY, value: refreshToken);
                  await storage.write(
                      key: ACCESS_TOKEN_KEY, value: accessToken);

                  // 로그인 성공시
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RootTab(),
                    ),
                  );
                  // resp.data => ACCESS 토큰과 REFRESH 토큰이 들어가 있는 맵
                  print('=============== 토큰 인코딩 token stringToBase64 encode');
                  print(resp.data); // .data => 응답받은 데이터값(body값)
                  print('===============');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
                child: const Text(
                  '로그인',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () async {
                  const refreshtoken =
                      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTcyMDE1NDc2OSwiZXhwIjoxNzIwMjQxMTY5fQ.6gwvnC9JIPaRiqisBfXSemrH9y4oHj8hSoOGpaqKhvk';

                  final resp = await dio.post(
                    'http://$ip/auth/token',

                    // Options => Dio 패키지에서 들어오는 패키지
                    // options: 파라미터 = 로그인에 필요한 데이터들
                    options: Options(
                      headers: {
                        'authorization': 'Bearer $refreshtoken',
                      },
                    ),
                  );
                  print('===============refreshtoken');
                  print(resp.data); // 회원가입 버튼을 누르면 accessToken값이 발급됨
                  print('===============');
                },
                style: TextButton.styleFrom(foregroundColor: PRIMARY_COLOR),
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

// 메인 타이틀
class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

// 서브 타이틀
class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요. \n오늘도 성공적인 주문이 되길 :)', // \n -> 개행
      style: TextStyle(fontSize: 16, color: BODY_TEXT_COLOR),
    );
  }
}
