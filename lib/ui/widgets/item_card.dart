import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget item;

  const ItemCard({
    super.key,
    required this.title,
    this.description,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withAlpha(150),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 4),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                description!,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          item,
        ],
      ),
    );
  }
}
