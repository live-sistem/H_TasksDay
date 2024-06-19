import 'package:flutter/material.dart';

class BetaPageGridPopover extends StatelessWidget {
  final void Function()? onEditTap;
  final void Function()? onDeleteTap;
  const BetaPageGridPopover({
    super.key,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    //возврощяем виджет Scaffold
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onEditTap!();
          },
          child: Container(
            height: 50,
            color: Theme.of(context).colorScheme.background,
            child: const Center(
                child: Text(
              'Редактировать',
              style: TextStyle(
                fontSize: 16,
              ),
            )),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onDeleteTap!();
          },
          child: Container(
            height: 50,
            color: const Color.fromARGB(255, 255, 17, 0),
            child: const Center(
              child: Text(
                'Удалить',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
