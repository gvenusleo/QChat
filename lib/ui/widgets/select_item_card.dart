import 'package:flutter/material.dart';
import 'package:qchat/ui/widgets/item_card.dart';

class SelectItemCard extends StatelessWidget {
  final String title;
  final String selectedItem;
  final List<String> items;
  final Function(String) onSelected;

  const SelectItemCard({
    super.key,
    required this.title,
    required this.selectedItem,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();

    return ItemCard(
      title: title,
      item: InkWell(
        onTap: () {
          final RenderBox button =
              key.currentContext!.findRenderObject()! as RenderBox;
          final RenderBox overlay = Overlay.of(key.currentContext!)
              .context
              .findRenderObject()! as RenderBox;
          final Offset offset = Offset(0.0, button.size.height);
          final RelativeRect position = RelativeRect.fromRect(
            Rect.fromPoints(
              button.localToGlobal(offset, ancestor: overlay),
              button.localToGlobal(
                  button.size.bottomRight(Offset.zero) + offset,
                  ancestor: overlay),
            ),
            Offset.zero & overlay.size,
          );
          showMenu(
            context: context,
            position: position,
            initialValue: selectedItem,
            items: [
              for (final item in items)
                PopupMenuItem(
                  value: item,
                  child: Text(item),
                  onTap: () {
                    onSelected(item);
                  },
                ),
            ],
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          key: key,
          height: 48,
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              selectedItem,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
