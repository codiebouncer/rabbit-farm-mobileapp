import 'package:flutter/material.dart';

class BreedingFilterBar extends StatelessWidget {
  final String selected;

  final ValueChanged<String> onSelected;

  const BreedingFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const filters = [
    'All',
    'Pregnant',
    'Due Soon',
    'Overdue',
    'Recent Births',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];

          final isSelected = filter == selected;

          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) {
              onSelected(filter);
            },
          );
        },
      ),
    );
  }
}
