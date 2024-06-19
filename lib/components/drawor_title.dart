import 'package:flutter/material.dart';

class DrawerTitle extends StatelessWidget {
  final String title;
  final Widget leading;
  final void Function()? onTap;
  const DrawerTitle({
    super.key,
    required this.title,
    required this.leading,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        leading: leading,
        onTap: onTap,
      ),
    );
  }
}
