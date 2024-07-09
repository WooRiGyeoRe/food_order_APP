import 'dart:convert';

import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

// (1) pubspec.yaml에 필요한 패키지들 설치

// (4) 터미널에 flutter pub run build_runner build 작성하고 실행하면
//     파트파일을 지정한 코드가 생성될 수 있는 모든 파일에서 코드를 생성시킬 수 있음 (일회성)
//     ======= 우리는 현재 class RestaurantModel에 대해 @JsonSerializable()을 작성했기 때문에
//             이 클래스에 대해 코드와 파일이 생성 됨(.g.dart 파일)
//             만약 안 생긴 경우 lib 오른쪽 클릭 - reload from disk 클릭
//     (+) .g.dart 파일 하위 폴더로 숨기기 : show options menu - file nesting - (마지막 , 세미콜론 옆에) .g.dart; 작성하고 OK
// 새 터미널을 추가해서 열어두고 flutter pub run build_runner build watch => 프로젝트에서 파일이 변경되는 걸 바라 봄(빌드 재시작 됨)
part 'restaurant_model.g.dart'; // (3) 작성 => 주의! g.dart

// JSON 데이터 매핑, JSON 생성자 만들어서 사용하기
// 더 간결해지고, 유지보수성도 좋아짐

enum RestaurantPriceRange { expensive, medium, cheap }

// 레스토랑 모델이라는 인스턴스와 그 속성들
@JsonSerializable() // (2) 해당 클리스를 Json-Serializable로 자동으로 코드를 생성시킬 것이다
class RestaurantModel {
  // 아래 속성들은 aip 요청으로부터 받을 응답에 대비해 정의해 둠 => 그래서 이름이 똑같음!
  final String id;
  final String name;
  // (7) 전환하는 방식을 변경하고 싶다면? => 그 속성 위에  @JsonKey 작성
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
  // (5) factory RestaurantModel 만들기
  // (5)-2. Map String, dynamic 타입으로 json 입력받을 거임! ----> 그럼 이제 restaurant_screen.dart에서 에러 발생할 것임!
  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json); // (5)-1. (json)은 어디에서 오느냐... => 입력받을 거임!

  // 이제 현재 인스턴스가 아니라 제이슨으로 바꿀 거니까...
  // (6) Json으로 바꿀 거니까 Map<String, dynamic>을 넣어주고 반환 / 이름은 항상 toJson / () 파라미터는 아무 것도 안 받음 / (this)는 현재 클래스
  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  // 무조건 static
  // value = @JsonKey를 달아줬던 thumbUrl
  static pathToUrl(String value) {
    return 'http://$ip$value';
  }

// 여기 fromJson => 이것도 아래 보면 반복적으로 속성을 또 넣어줘야 함...
// tags, priceRange 파라미터 빼면 사실 그냥 반복되어 속성을 넣어주고 있음.
// 키 값도 똑같고
// -----------------> 그럼 이것도 뭔가 자동화할 수 있지 않을까??? 라는 생각이 들게 됨.
//                    ☆ 이러한 자동화를 돕는 게 바로 JSON Serializable ☆
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
