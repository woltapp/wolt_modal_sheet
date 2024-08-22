import 'package:coffee_maker_navigator_2/app/router/entities/app_route_path.dart';

class AppRouteConfiguration {
  final AppRoutePath appRoutePath;
  final Map<String, String> queryParams;

  static const queryParamId = 'id';

  const AppRouteConfiguration({
    required this.appRoutePath,
    this.queryParams = const {},
  });

  Uri toUri() => Uri(path: appRoutePath.path, queryParameters: queryParams);
}
