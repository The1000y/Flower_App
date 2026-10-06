import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_occasion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomOccasionrList extends StatelessWidget {
  final List<OccasionEntity> occasionList;
  const CustomOccasionrList({super.key, required this.occasionList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollCacheExtent: ScrollCacheExtent.pixels(500), scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 16),
        itemCount: occasionList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return OccasionCard(occasion: occasionList[index]);
        },
      ),
    );
  }
}
