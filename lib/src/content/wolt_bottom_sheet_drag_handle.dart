import 'package:flutter/material.dart';

class WoltBottomSheetDragHandle extends StatelessWidget {
  const WoltBottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    const Size handleSize = Size(32, 4);

    return Semantics(
      label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      container: true,
      child: SizedBox(
        height: kMinInteractiveDimension,
        width: kMinInteractiveDimension,
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
