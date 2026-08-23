import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/bestSeller/product_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_section_type.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/product_list.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/section_content_view.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/section_header.dart';
import 'package:flutter/material.dart';

class BestSellerSection extends StatelessWidget {
  final HomeEntity section;
  final BaseState<List<BestSellerEntity>> bestSellersState;

  const BestSellerSection({
    super.key,
    required this.section,
    required this.bestSellersState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.displayTitle != null)
          SectionHeader(title: section.displayTitle!),
        const SizedBox(height: 16),
        SectionContentView<BestSellerEntity>(
          sectionState: bestSellersState,
          builder: (context, products) => ProductList(products: products),
        ),
      ],
    );
  }
}
