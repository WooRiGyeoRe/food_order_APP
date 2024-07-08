import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/restaurant/moedl/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard(
      {super.key,
      required this.image,
      required this.name,
      required this.detail,
      required this.price});

  factory ProductCard.fromModel({
    required RestaurantProductModel model,
  }) {
    return ProductCard(
        image: Image.network(model.imgUrl,
            width: 110, height: 110, fit: BoxFit.cover),
        name: model.name,
        detail: model.detail,
        price: model.price);
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusDirectional.circular(8),
            child: image,

            //Image.asset('asset/img/food/ddeok_bok_gi.jpg',
            //width: 110, height: 110, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // 좌우로 최대한 늘리기
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name, //'떡볶이',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  // '전통 떡볶이의 정석! 정말 맛있습니다~ \n얼마나 맛있을지 궁금하시죠? 그럼 직접 한 번 주문해서 드셔보시는 건 어떠신가요?!',
                  detail,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '￦$price', // '￦10000',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
