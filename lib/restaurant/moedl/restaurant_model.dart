import 'dart:convert';

import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

// 터미널에 flutter pub run build_runner build 작성하고 실행하면
// 파트파일을 지정한 코드가 생성될 수 있는 모든 파일에서 코드를 생성시킬 수 있음 (1회성)
// 새 터미널을 추가해서 열어두고 flutter pub run build_runner build watch => 프로젝트에서 파일이 변경되는 걸 바라 봄(빌드 재시작 됨)
part 'restaurant_model.g.dart';

// JSON 데이터 매핑, JSON 생성자 만들어서 사용하기
// 더 간결해지고, 유지보수성도 좋아짐

enum RestaurantPriceRange { expensive, medium, cheap }

// 레스토랑 모델이라는 인스턴스와 그 속성들
@JsonSerializable() // 해당 클리스를 Json-Serializable로 자동으로 코드를 생성시킬 것이다
class RestaurantModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
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

  // (json)은 어디서 올까? => 우리가 입력 받을 거임!
  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  // 이제 현재 인스턴스가 아니라 제이슨으로 바꿀 거니까...
  // (this)는 현재 클래서
  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  // 무조건 static
  static pathToUrl(String value) {
    return 'http://$ip$value';
  }

//   factory RestaurantModel.fromJson({
//     // Dart에서는 api를 통해 json값을 가져와서 그 값을 넣을 때,
//     // List가 아닌 이상 무조건 Map<String, dynamic> 으로 표현함!!!!
//     required Map<String, dynamic> json,
//   }) {
//     return RestaurantModel(
//         id: json['id'],
//         name: json['name'],
//         thumbUrl: 'http://$ip${json['thumbUrl']}',
//         tags: List<String>.from(json['tags']),
//         priceRange: RestaurantPriceRange.values.firstWhere(
//           (e) => e.name == json['priceRange'],
//         ),
//         ratings: json['ratings'],
//         ratingsCount: json['ratingsCount'],
//         deliveryTime: json['deliveryTime'],
//         deliveryFee: json['deliveryFee']);
//   }
}
