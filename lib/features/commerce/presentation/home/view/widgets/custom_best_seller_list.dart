import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_best_seller_card.dart';
import 'package:flutter/material.dart';

class CustomBestSellerList extends StatelessWidget {
  const CustomBestSellerList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(16, 0),
      child: SizedBox(
        height: 240,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: 10,
          separatorBuilder: (context, index) =>
              const SizedBox(width: 16),
          itemBuilder: (context, index) {
            return const BestSellerCard();
          },
        ),
      ),
    );
  }
}