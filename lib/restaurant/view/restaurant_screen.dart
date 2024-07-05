import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/restaurant/component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  // Future
  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {'authorization': 'Bearer $accessToken'},
      ),
    );
    // 가져오고 싶은 값 = 데이터라는 키 안에 있는 값들만 반환 => 그래야 List 값을 가져올 수 있음
    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // <List> => 어떤 값이 들어오는지 확인하기 위해 작성
          child: FutureBuilder<List>(
              future: paginateRestaurant(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                // snapshot.hasData 데이터가 없으면 -> 일단... 컨테이너 반환(좋은 방법은 아니지만ㅋㅋㅋ)
                if (!snapshot.hasData) {
                  return Container();
                }
                // snapshot.data.length => 몇 개의 아이템인지 알 수 있음
                return ListView.separated(
                  itemCount: snapshot
                      .data!.length, // 느낌표를 쓴 이유 => 데이터가 없으면 위에서 이미 걸리기 때문
                  // itemBuilder는 인덱스를 받아서 각 아이템별로 렌더링해 줄 수 있음
                  itemBuilder: (_, index) {
                    return RestaurantCard(
                      // fit: BoxFit.cover => 전체를 차지하게
                      image: Image.asset('asset/img/food/ddeok_bok_gi.jpg',
                          fit: BoxFit.cover),
                      name: '불타는 떡볶이',
                      tags: const ['떡볶이', '치즈', '매운맛'],
                      ratingsCount: 100,
                      deliveryTime: 15,
                      deliveryFee: 2000,
                      ratings: 4.52,
                    );
                  },
                  // separatorBuilder => 각각 아이템 사이사이에 들어가는 것을 빌드하는 방법
                  separatorBuilder: (_, index) {
                    return const SizedBox(height: 16);
                  },
                );
              }),
        ),
      ),
    );
  }
}
