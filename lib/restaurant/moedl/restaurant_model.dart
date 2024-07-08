import 'package:flutter_actual/common/const/data.dart';

// JSON 데이터 매핑, JSON 생성자 만들어서 사용하기
// 더 간결해지고, 유지보수성도 좋아짐

enum RestaurantPriceRange { expensive, medium, cheap }

// 레스토랑 모델이라는 인스턴스와 그 속성들

class RestaurantModel {
  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  // 인스턴스화 할 때 => 파라미터로 값을 꼭 넣어줘야 되게 하기 위해서
  RestaurantModel(
      {required this.id,
      required this.name,
      required this.thumbUrl,
      required this.tags,
      required this.priceRange,
      required this.ratings,
      required this.ratingsCount,
      required this.deliveryTime,
      required this.deliveryFee});

  factory RestaurantModel.fromJson({
    // Dart에서는 api를 통해 json값을 가져와서 그 값을 넣을 때,
    // List가 아닌 이상 무조건 Map<String, dynamic> 으로 표현함!!!!
    required Map<String, dynamic> json,
  }) {
    return RestaurantModel(
        id: json['id'],
        name: json['name'],
        thumbUrl: 'http://$ip${json['thumbUrl']}',
        tags: List<String>.from(json['tags']),
        priceRange: RestaurantPriceRange.values.firstWhere(
          (e) => e.name == json['priceRange'],
        ),
        ratings: json['ratings'],
        ratingsCount: json['ratingsCount'],
        deliveryTime: json['deliveryTime'],
        deliveryFee: json['deliveryFee']);
  }
}
