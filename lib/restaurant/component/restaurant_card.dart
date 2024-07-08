import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/restaurant/moedl/restaurant_detail_model.dart';
import 'package:flutter_actual/restaurant/moedl/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  // 이미지
  final Widget image;

  // 레스토랑 이름
  final String name;

  // 레스토랑 태그
  // List로 값들을 넣을 거임!
  final List<String> tags;

  // 평점 갯수
  final int ratingsCount;

  // 배송걸리는 시간
  final int deliveryTime;

  // 배송 비용
  final int deliveryFee;

  // 평균 평점
  final double ratings;

  // 상세 카드 여부
  final bool isDetail;

  // 상세 내용 -> null일 수도 있으니까(isDetail이 false일때) 물음표 넣어주기
  final String? detail;

  // Hero 위젯 태그
  final String? heroKey;

  const RestaurantCard({
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    // 디폴트 값은 false => 왜? =>
    // 이미 구현한 게 detail에 해당되지 않는 데이터에 대해서 값을 구현해놨기 때문
    this.isDetail = false,
    this.detail,
    this.heroKey,
    super.key,
  });

  factory RestaurantCard.fromModel(
      {required RestaurantModel model, bool isDetail = false}) {
    return RestaurantCard(
      image: Image.network(model.thumbUrl, fit: BoxFit.cover),
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (isDetail) image,
      if (!isDetail)

        // ClipRRect => 테두리 깎기
        ClipRRect(
          borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0), // 깎을 양, 모양
          child: image, // 깎을 것
        ),
      const SizedBox(height: 16),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: isDetail ? 16 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              // tags.join => .join 사용해서 값을 한번에 합치기
              // tags.join('원하는 값')이라고 쓰면 합칠 때 원하는 값도 지정할 수 있음
              tags.join(' · '),
              style: const TextStyle(
                color: BODY_TEXT_COLOR,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                _IconText(
                  icon: Icons.star,
                  label: ratings.toString(),
                ),
                renderDot(),
                _IconText(
                  icon: Icons.receipt,
                  label: ratingsCount.toString(),
                ),
                renderDot(),
                _IconText(
                  icon: Icons.timelapse_outlined,
                  label: '$deliveryTime 분',
                ),
                renderDot(),
                _IconText(
                  icon: Icons.monetization_on,
                  label: deliveryFee == 0 ? '무료' : deliveryFee.toString(),
                  // 배달비가 0이면 무료, 아니면 DeliveryFee.toString
                ),
              ],
            ),
            // 만약 detail이 null이 아니고 isDetail이 true면, 아래 실행
            if (detail != null && isDetail)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(detail!),
              ),
          ],
        ),
      ),
    ]);
  }

  Widget renderDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        '·',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14.0,
        ),
        const SizedBox(width: 8.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
