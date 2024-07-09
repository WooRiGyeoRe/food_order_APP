import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/common/dio/dio.dart';
import 'package:flutter_actual/common/layout/default_layout.dart';
import 'package:flutter_actual/product/component/product_card.dart';
import 'package:flutter_actual/restaurant/component/restaurant_card.dart';
import 'package:flutter_actual/restaurant/moedl/restaurant_detail_model.dart';
import 'package:flutter_actual/restaurant/repository/restaurant_repository.dart';

class RestaurantDetailScreen extends StatelessWidget {
  // 레스토랑 정보 api 가져오기 (필요한 것: 레스토랑 ID, Bearer 토큰)
  // 회원이 누른 레스토랑 ID (builder: (_) => const RestaurantDetailScreen()로 가서 id를 넣어주자~)
  final String id;

  const RestaurantDetailScreen({super.key, required this.id});

  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    final repository =
        RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    return repository.getRestaurantDetail(
        id: id); // 그럼 이제  Future<Map<String, dynamic>> 이게 아니라  Future<RestaurantDetailModel> , 아래도 이제 <RestaurantDetailModel>

    /*
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    // api 요청
    final resp = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(
        headers: {'authorization': 'Bearer $accessToken'},
      ),
    );
    return resp.data; // 요청 반환 ⊙
    */
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      // 밑으로 스크롤하면 평점이 나오게 (평점은 api에서 불러 올거임)
      child: FutureBuilder<RestaurantDetailModel>(
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          // print(snapshot.data);
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /* <RestaurantDetailModel> 이후부터 더 이상 이 아템은 필요없게 됨 
              snapshot에서 맵핑된 모델이 나오기 때문에 
          // ⊙ 모델로 변경
          final item = RestaurantDetailModel.fromJson(snapshot.data!);
          // fromJson(json: snapshot.data!);수정 => 컨스트럭터로 바꿨기 때문에 json 삭제
          */

          return CustomScrollView(
            slivers: [
              renderTop(model: snapshot.data! // <= item,
                  ),
              renderLable(),
              renderProducts(
                  products: snapshot.data!.products // <= item.products,
                  ),
            ],
          );
        },
      ),
    );
  }

  SliverPadding renderLable() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  SliverPadding renderProducts(
      {required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ProductCard.fromModel(model: model),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    // 일반 위젯을 넣으려면 SliverToBoxAdapter 작성!
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
        /*
        image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
        name: '불타는 떡볶이',
        tags: const ['떡볶이', '짜장', '치즈'],
        ratingsCount: 100,
        deliveryTime: 30,
        deliveryFee: 3000,
        ratings: 4.76,
        isDetail: true,
        detail: '맛있는 떡볶이',
        */
      ),
    );
  }
}
