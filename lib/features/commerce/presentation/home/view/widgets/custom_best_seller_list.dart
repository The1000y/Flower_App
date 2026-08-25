// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_best_seller_card.dart';
import 'package:flutter/rendering.dart';

class CustomBestSellerList extends StatelessWidget {
  final List<BestSellerEntity> bestSellerlist;
  const CustomBestSellerList({super.key, required this.bestSellerlist});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollCacheExtent: ScrollCacheExtent.pixels(500), scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 16),
        itemCount: bestSellerlist.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return  BestSellerCard(bestSellerEntity: bestSellerlist[index]);
        },
      ),
    );
  }
}
