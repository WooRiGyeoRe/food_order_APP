import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/restaurant/component/restaurant_card.dart';
import 'package:flutter_actual/restaurant/moedl/restaurant_model.dart';
import 'package:flutter_actual/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  // Future로 된 <List>를 반환 => 왜 Future로 반환? => async로
  // 함수를 선언했기 때문
  // --------------------------------------------------------------------
  // 그럼 왜 async로 선언했냐? => http 요청을 할거라서(dio)
  // 'http://$ip/restaurant' 여기에 요청하면  resp.data 안에
  // 우리가 포스트맨에서 요청한 메타와 데이터를 포함한 전체 오브젝트 값이 body에 들어옴
  // --------------------------------------------------------------------
  // 그런데 우리가 원하는건 data 키에 있는 리스트 값!
  // 그래서 resp.data에 데이터 키를 넣고 반환해 준 것임 => return resp.data['data']; => @1

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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // snapshot.data.length => 몇 개의 아이템인지 알 수 있음
                // @1를 반환 받으면 값을 어디서 가져올 수 있냐? =>  snapshot.data!.lengt에서 가져올 수 있음
                //  snapshot.data => 각각의 레스토랑 정보가 들어있음
                return ListView.separated(
                  itemCount: snapshot
                      .data!.length, // 느낌표를 쓴 이유 => 데이터가 없으면 위에서 이미 걸리기 때문
                  // itemBuilder는 인덱스를 받아서 각 아이템별로 렌더링해 줄 수 있음
                  itemBuilder: (_, index) {
                    // 아이템 빌더가 실행될 때마다 0번째부터 20번째 아이템이 하나씩 선택이 됨
                    final item = snapshot.data![index];
                    // final pItem2 = RestaurantModel.fromJson(json: item);
                    final pItem = RestaurantModel.fromJson(json: item);
                    // parsed

                    /* 여기에서의 아이템과 위에 안에서의 제이슨은 같은 값임! 
                      pItem2를 pItem으로 바꿔주자~ 
                      
                    final pItem = RestaurantModel(
                        id: item['id'],
                        name: item['name'],
                        //thumbUrl: item['thumbUrl'],
                        thumbUrl: 'http://$ip${item['thumbUrl']}',
                        tags: List<String>.from(item['tags']),
                        // valuese들을 하나씨 맵핑하면서 값을 찾는 것
                        // => 어떤 값? = > 레스토랑 Model에 있는  expensive, medium, cheap 중에서 똑같은 값(똑같은 아이템의 priceRange와 똑같은 값을 찾는다)
                        priceRange: RestaurantPriceRange.values.firstWhere(
                          (e) => e.name == item['priceRange'],
                        ),
                        ratings: item['ratings'],
                        ratingsCount: item['ratingsCount'],
                        deliveryTime: item['deliveryTime'],
                        deliveryFee: item['deliveryFee']);
                        */

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                RestaurantDetailScreen(id: pItem.id),
                          ),
                        );
                      },
                      child: RestaurantCard.fromModel(model: pItem

                          /*
                        // 이 값들은 restaurant_card.dart 으로 이동  factory RestaurantCard.fromMode 
                        image: Image.network(
                          'http://$ip${item['thumbUrl']}', // 이미지들을 item 변수에서 가져와서 네트워크 요청으로부터 가져와 실제 썸네일로 저장된 URL을 기반으로 이미지를 가져왔기 때문
                            pItem.thumbUrl,
                            fit: BoxFit.cover),
                        fit: BoxFit.cover => 전체를 차지하게
                        image: Image.asset('asset/img/food/ddeok_bok_gi.jpg',
                           fit: BoxFit.cover),

                        List< >.from => 어떤 걸로부터 리스트를 만들겠다
                        <String>으로 구성된!
                        어떤 걸로부터 만들건지는 from 다음 괄호 안에 넣으면 됨 -> .from(item['tags'])
                        /*
                      name: item['name'], // name: '불타는 떡볶이',
                      tags: List<String>.from(
                          item['tags']), // tags: const ['떡볶이', '치즈', '매운맛'],
                      ratingsCount: item['ratingsCount'], // ratingsCount: 100,
                      deliveryTime: item['deliveryTime'], // deliveryTime: 15,
                      deliveryFee: item['deliveryFee'], // deliveryFee: 2000,
                      ratings: item['ratings'], // ratings: 4.52,
                      */
                        name: pItem.name,
                        tags: pItem.tags,
                        ratingsCount: pItem.ratingsCount,
                        deliveryTime: pItem.deliveryTime,
                        deliveryFee: pItem.deliveryFee,
                        ratings: pItem.ratings);
                        */

                          ),
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
