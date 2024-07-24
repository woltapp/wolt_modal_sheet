import 'package:flutter/material.dart';
import 'container_manager.dart';

class Injector extends InheritedWidget {
  final ContainerManager containerManager;

  const Injector({
    Key? key,
    required Widget child,
    required this.containerManager,
  }) : super(key: key, child: child);

  static ContainerManager of(BuildContext context) {
    final Injector? injector =
        context.getInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'No Injector found in context');
    return injector!.containerManager;
  }

  void requireContainer<C>(Object subscriber) {
    containerManager.requireContainer<C>(subscriber);
  }

  releaseContainer<C>(Object subscriber) {
    containerManager.releaseContainer<C>(subscriber);
  }

  C getContainer<C>() {
    return containerManager.getContainer<C>();
  }

  @override
  bool updateShouldNotify(Injector oldWidget) {
    return false;
  }
}
