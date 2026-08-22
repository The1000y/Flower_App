import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_category_item.dart';
import 'package:flutter/material.dart';

class CustomCategoryList extends StatelessWidget {
  const CustomCategoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
       offset: const Offset(16, 0),
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 16,
            );
          },
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (context, index) {
            return CustomCategoryWidget();
                      
        },),
      ),
    );
  }
}

