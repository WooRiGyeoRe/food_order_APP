import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/common/utils/data_utils.dart';
import 'package:flutter_actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart'; // JsonSerializable 사용을 위해 작성

part 'restaurant_detail_model.g.dart'; // JsonSerializable 사용을 위해 작성

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;

  // final List <Map<String, dynamic>>  -> 맵을 사용해 키 값이 뭔지 모르는 문제 발생!
  // -> 이게 싫으니까 아래 RestaurantProductModel 만들어버리기
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    // RestaurantModel를 상속받아 이미 존재하는 값들
    required super.id,
    required super.name,
    @JsonKey(
      fromJson: DataUtils.pathToUrl,
    )
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    // 추가된 부분은 선언해주기
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDetailModelFromJson(json);

  // => @JsonSerializable() 사용할 거라서 삭제하기
  // factory RestaurantDetailModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantDetailModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: 'http://$ip${json['thumbUrl']}',
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values.firstWhere(
  //       (e) => e.name == json['priceRange'],
  //     ),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //     detail: json['detail'],
  //     products: json['products']
  //         .map<RestaurantProductModel>(
  //           (x) => RestaurantProductModel.fromJson(
  //             json: x,
  //             //   id: x['id'],
  //             //   name: x['name'],
  //             //   imgUrl: x['imgUrl'],
  //             //   detail: x['detail'],
  //             //   price: x['price'],
  //           ),
  //         )
  //         .toList(),
  //   );
  // }
}

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantProductModelFromJson(json);

  // factory RestaurantProductModel.fromJson(
  //     {required Map<String, dynamic> json}) {
  //   return RestaurantProductModel(
  //     id: json['id'],
  //     name: json['name'],
  //     imgUrl: 'http://$ip${json['imgUrl']}',
  //     detail: json['detail'],
  //     price: json['price'],
  //   );
  // }
}
