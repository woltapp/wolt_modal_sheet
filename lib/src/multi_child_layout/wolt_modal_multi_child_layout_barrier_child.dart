import 'package:flutter/material.dart';

class WoltModalMultiChildLayoutBarrierChild extends StatelessWidget {
  const WoltModalMultiChildLayoutBarrierChild({
    this.onTap,
    super.key,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap?.call();
        Navigator.of(context).pop();
      },
      child: const SizedBox.expand(),
    );
  }
}
