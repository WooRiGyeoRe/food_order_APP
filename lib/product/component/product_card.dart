import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusDirectional.circular(8),
            child: Image.asset('asset/img/food/ddeok_bok_gi.jpg',
                width: 110, height: 110, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // 좌우로 최대한 늘리기
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '떡볶이',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  '전통 떡볶이의 정석! 정말 맛있습니다~ \n얼마나 맛있을지 궁금하시죠? 그럼 직접 한 번 주문해서 드셔보시는 건 어떠신가요?!',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '￦10000',
                  textAlign: TextAlign.right,
                  style: TextStyle(
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
