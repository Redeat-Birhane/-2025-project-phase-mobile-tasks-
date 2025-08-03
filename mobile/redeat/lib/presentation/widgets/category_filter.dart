import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: categories.map((category) {
        return ChoiceChip(
          label: Text(category),
          selected: selectedCategory == category,
          onSelected: (selected) {
            onCategorySelected(selected ? category : '');
          },
        );
      }).toList(),
    );
  }
}
