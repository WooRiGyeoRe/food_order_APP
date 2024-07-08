import 'package:flutter/material.dart';
import 'package:flutter_actual/common/layout/default_layout.dart';
import 'package:flutter_actual/product/component/product_card.dart';
import 'package:flutter_actual/restaurant/component/restaurant_card.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      // 밑으로 스크롤하면 평점이 나오게 (평점은 api에서 불러 올거임)
      child: CustomScrollView(
        slivers: [
          renderTop(),
          renderProducts(),
        ],
      ),
    );
  }

  renderProducts() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const ProductCard();
        },
        childCount: 10,
      ),
    );
  }

  SliverToBoxAdapter renderTop() {
    // 일반 위젯을 넣으려면 SliverToBoxAdapter 작성!
    return SliverToBoxAdapter(
      child: RestaurantCard(
        image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
        name: '불타는 떡볶이',
        tags: const ['떡볶이', '짜장', '치즈'],
        ratingsCount: 100,
        deliveryTime: 30,
        deliveryFee: 3000,
        ratings: 4.76,
        isDetail: true,
        detail: '맛있는 떡볶이',
      ),
    );
  }
}
