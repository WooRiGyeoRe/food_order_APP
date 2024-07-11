import 'package:dio/dio.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

// 1) 요청 보낼 때
// 요청이 보내질 때마다 만약에 요청의 Header에 accessToken : true라는 값이 있다면,
// 실제 토큰을 (storage에서) 가져와서 authorization : Bearer $token으로 Header를 변경
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

// 2) 응답 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // response 안에 어떤 요청인지 확인하는 방법
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

// 3) 에러 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러 (status code)
    // 토큰을 재발급 받는 시도를 하고, 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken 아예 없으면 당연히 에러를 던진다
    if (refreshToken == null) {
      // 에러를 던질 때는 handler.reject 사용
      return handler.reject(err);
    }

    // 해당 서버에서의 401 에러 = 토큰 오류
    final isStatus401 = err.response?.statusCode == 401;
    // 요청 자체가 에러난 요청이 '/auth/token' url. 즉, 원래 새로 토큰을 발급받으려던 요청이었으면 그 값을 isPathRefresh에 담아줌
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // 먄약에 401 에러를 받았고 && 토큰을 리프레쉬할 의도가 아니라면 (토큰을 리프레쉬할 의도가 아니었는데 401 에러가 났다면)
    // => 무언가 엑세스 토큰을 필요로 하는 요청에서 에러가 발생함을 알 수 있음
    // => 이럴 떤 새로 토큰을 발급받는 시도를 해 주자!
    if (isStatus401 && !isPathRefresh) {
      // 토큰 발급 시도하기
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );
        // 이 요청에서 실제 accessToken을 가져오려면 데이터에서 accessToken이란 값을 가져와야 함
        final accessToken = resp.data['accessToken'];

        // 에러를 발생시킨 모든 요청과 관련된 옵션들을 다 받고, 아래에서 토큰만 바꾼 다음 요청 재전송하는 과정
        final options = err.requestOptions;

        // 새로 받은 토큰으로 변경하기
        options.headers.addAll(
          {'authorization': 'Bearer $accessToken'},
        );

        // 새로 받아 변경된 토큰은 FlutterSecureStorage storage에서도 업데이트 하기!!!
        //  -> 그렇지 않으면? -> 이번 요청에서만 새로 발급된 토큰 사용하고, 다음 요청에서는 원래 SecureStorage 안에 있던 토큰 그대로 사용
        // FlutterSecureStorage storage 안에 ACCESS_TOKEN_KEY에 실제 accessToken을 넣어주기
        // 그러면 ACCESS_TOKEN_KEY를 가져올 때마다 새로 발급받은 accessToken을 가져올 수 있게 됨.
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);
        // handler.resolve = 요청이 성공했다는 것을 반환(에러가 난 상태라더라도)
        // (response) => 요청 재전송의 response(응답)를 받아서 handler.resolve에 넣으면 에러난 상황에
        //               요청을 토큰만 바꿔서 새로 요청한 다음 성공적인 요청에 대한 값을 반환할 수 있게 됨
        //            => 실제론 에러가 났지만, 새로 요청해서 응답을 받아온 다음 handler.resolve를 불렀기 때문에
        //               Interceptors를 적용한 dio를 사용하면, 실제로 에러나지 않은 것같은 효과를 줄 수 있음
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e); // handler.reject => 그대로 에러 반환
      }
    }
    return handler.reject(err); // 최상위 에러 reject
    // return super.onError(err, handler);
  }
}
