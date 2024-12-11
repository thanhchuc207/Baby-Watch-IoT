import 'package:flutter/material.dart';

class ListCategoryWidget extends StatelessWidget {
  const ListCategoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            CategoryButton(
              label: 'High tech',
              isSelected: true,
            ),
            CategoryButton(
              label: 'News',
            ),
            CategoryButton(
              label: 'Music',
            ),
            CategoryButton(
              label: 'All',
            ),
            CategoryButton(
              label: 'Gaming',
            ),
          ],
        ),
      ),
    );
  }
}

// Widget CategoryButton
class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CategoryButton({
    super.key,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Colors.white,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
