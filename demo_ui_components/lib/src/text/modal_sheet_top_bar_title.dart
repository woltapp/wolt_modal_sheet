import 'package:flutter/material.dart';

class ModalSheetTopBarTitle extends StatelessWidget {
  const ModalSheetTopBarTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleSmall);
  }
}
