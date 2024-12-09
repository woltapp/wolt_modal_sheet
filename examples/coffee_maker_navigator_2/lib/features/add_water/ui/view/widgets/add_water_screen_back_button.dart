import 'package:flutter/material.dart';

class AddWaterScreenBackButton extends StatelessWidget {
  const AddWaterScreenBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0) +
            EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: BackButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: Navigator.of(context).pop,
        ),
      ),
    );
  }
}
