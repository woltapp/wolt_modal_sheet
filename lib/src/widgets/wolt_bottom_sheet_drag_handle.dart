import 'package:flutter/material.dart';

class WoltBottomSheetDragHandle extends StatelessWidget {
  const WoltBottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    const Size handleSize = Size(36, 4);

    return Semantics(
      label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      container: true,
      child: SizedBox(
        height: 24,
        width: 48,
        child: Center(
          child: Container(
            height: handleSize.height,
            width: handleSize.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(handleSize.height / 2),
              color: Colors.black12,
            ),
          ),
        ),
      ),
    );
  }
}
