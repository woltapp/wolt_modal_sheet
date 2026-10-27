import 'package:coffee_maker_navigator_2/features/login/ui/view/widgets/login_screen_content.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'LoginScreenContent',
  type: LoginScreenContent,
  path: 'Login/Widgets',
)
Widget loginScreenContent(BuildContext context) {
  return LoginScreenContent(
    onLoginPressed: (_, __) {},
  );
}
