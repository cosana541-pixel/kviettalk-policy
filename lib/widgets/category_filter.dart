import 'package:flutter/material.dart';

import '../utils/category_labels.dart';

// 카테고리 선택 칩을 재사용하기 위한 작은 위젯입니다.
class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  static const String allCategoryLabel = 'all';

  @override
  Widget build(BuildContext context) {
    final allCategories = <String>[allCategoryLabel, ...categories];

    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = allCategories[index];

          return ChoiceChip(
            label: Text(categoryLabelVi(category)),
            selected: selectedCategory == category,
            showCheckmark: false,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            onSelected: (_) => onChanged(category),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: allCategories.length,
      ),
    );
  }
}
