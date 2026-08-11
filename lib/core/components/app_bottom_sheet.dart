import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet(
      {super.key, required this.widget, required this.textBottomSheet});
  final Widget widget;
  final String textBottomSheet;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        enableDrag: true,
        showDragHandle: true,
        onClosing: () {},
        builder: (context) => SizedBox(
            height: 260,
            child: Column(children: [
              Text(
                textBottomSheet,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: widget,
              )
            ])));
  }
}
