import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Widget? icon;
  final String title;
  final Widget? trailing;
  final Function() onTap;
  final Color? color;
  final bool topRadius;
  final bool bottomRadius;

  const ListItem({
    super.key,
    this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
    this.color,
    this.topRadius = true,
    this.bottomRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: trailing,
      onTap: onTap,
      tileColor: Theme.of(context).colorScheme.surfaceVariant.withAlpha(150),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topRadius ? 12 : 0),
          bottom: Radius.circular(bottomRadius ? 12 : 0),
        ),
      ),
    );
  }
}
