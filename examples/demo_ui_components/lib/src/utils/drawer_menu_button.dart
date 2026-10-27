import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:material_ui/material_ui.dart';

class DrawerMenuButton extends StatelessWidget {
  const DrawerMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 40,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
          color: WoltColors.black8,
        ),
        child: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }
}
