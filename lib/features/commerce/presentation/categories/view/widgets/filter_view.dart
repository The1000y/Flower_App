import 'package:flutter/material.dart';
import 'package:flower_app/l10n/l10n.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/themes/app_colors/app_color.dart';
import 'build_sort_item_filter.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key, this.selectedSort, required this.onChanged});

  final SortType? selectedSort;
  final ValueChanged<SortType?> onChanged;

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  SortType? selectedSort;

  @override
  void initState() {
    super.initState();
    selectedSort = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Text(
            context.l10n.sortBy,
            style: TextStyle(
              color: AppColors.pinkBase,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        BuildSortItemFilter(
          title: context.l10n.sortRecommended,
          value: SortType.recommended,
          groupValue: selectedSort,
          onChanged: (value) {
            setState(() => selectedSort = value);
            widget.onChanged(value);
          },
        ),

        BuildSortItemFilter(
          title: context.l10n.sortNewest,
          value: SortType.newest,
          groupValue: selectedSort,
          onChanged: (value) {
            setState(() => selectedSort = value);
            widget.onChanged(value);
          },
        ),

        BuildSortItemFilter(
          title: context.l10n.sortPriceLowToHigh,
          value: SortType.priceLowToHigh,
          groupValue: selectedSort,
          onChanged: (value) {
            setState(() => selectedSort = value);
            widget.onChanged(value);
          },
        ),

        BuildSortItemFilter(
          title: context.l10n.sortPriceHighToLow,
          value: SortType.priceHighToLow,
          groupValue: selectedSort,
          onChanged: (value) {
            setState(() => selectedSort = value);
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}
