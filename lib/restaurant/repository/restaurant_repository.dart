import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_actual/restaurant/moedl/restaurant_detail_model.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

// 레포지토리 클래스는 무조건 abstract로 선언 => 인스턴스화가 안 되게
// baseUrl => 이 레포지토리 안에서 공통되는 url
@RestApi()
abstract class RestaurantRepository {
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // @GET('/') // http://$ip/restaurant
  // paginate();

  // 레스토랑 상세 정보 가져오기
  @GET('/{id}') // http://$ip/restaurant/$id
  @Headers({'accessToken': 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
