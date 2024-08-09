import 'package:flutter/foundation.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

typedef ObjectFactory<T> = T Function(Injector i);

class DependencyInjection {
  static final _injector = Injector();
  static final _mockedTypes = <Type>[];

  static void bind<T>(ObjectFactory<T> factoryFn,
      {bool isSingleton = false, String? key}) {
    if (_mockedTypes.contains(T)) {
      debugPrint('$T is mocked, skipping');
    } else {
      _injector.map<T>((i) => factoryFn(i), isSingleton: isSingleton, key: key);
    }
  }

  static void disposeInjection() {
    _injector.dispose();
    _mockedTypes.clear();
  }

  static T get<T>({String? key, Map<String, dynamic>? additionalParameters}) {
    return _injector.get<T>(
        key: key, additionalParameters: additionalParameters);
  }
}
