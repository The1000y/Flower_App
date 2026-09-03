import 'package:flower_app/core/constants/app_strings/app_strings.dart'
    show AppStrings;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/themes/app_colors/app_color.dart';
import 'buildSortItemfFilter.dart';

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
            AppStrings.sortBy,
            style: TextStyle(
              color: AppColors.pinkBase,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        BuildSortItemFilter(
          title: 'Recommended',
          value: SortType.recommended,
          groupValue: selectedSort,
          onChanged: (value) {
            setState(() => selectedSort = value);
            widget.onChanged(value);
          },
        ),

        BuildSortItemFilter(
          title: 'Newest',
          value: SortType.newest,
          groupValue: selectedSort,
          onChanged: (value) {
            setState(() => selectedSort = value);
            widget.onChanged(value);
          },
        ),

        BuildSortItemFilter(
          title: 'Price Low To High',
          value: SortType.priceLowToHigh,
          groupValue: selectedSort,
          onChanged: (value) {
            setState(() => selectedSort = value);
            widget.onChanged(value);
          },
        ),

        BuildSortItemFilter(
          title: 'Price High To Low',
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
