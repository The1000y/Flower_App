import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_section_type.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/section_content_view.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class OccasionsSection extends StatelessWidget {
  final HomeEntity section;
  final BaseState<List<OccasionEntity>> occasionsState;

  const OccasionsSection({
    super.key,
    required this.section,
    required this.occasionsState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.displayTitle != null)
          SectionHeader(title: section.displayTitle!),
        SizedBox(height: 16.h),
        SectionContentView<OccasionEntity>(
          sectionState: occasionsState,
          loadingHeight: 160.h,
          builder: (context, occasions) => SizedBox(
            height: 160.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: occasions.length,
              separatorBuilder: (context, index) => SizedBox(width: 16.w),
              itemBuilder: (context, index) =>
                  _OccasionItem(occasion: occasions[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _OccasionItem extends StatelessWidget {
  final OccasionEntity occasion;

  const _OccasionItem({required this.occasion});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24.r),
          child: Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.lightPink,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Image.network(
              occasion.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.error_outline,
                color: AppColors.pinkBase,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(occasion.name, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
