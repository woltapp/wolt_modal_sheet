import 'package:coffee_maker_navigator_2/di/di/injector.dart';
import 'package:flutter/material.dart';

mixin IContainerSubscriber<C, T extends StatefulWidget> on State<T>{
  @override
  void initState() {
    super.initState();
    Injector.of(context).requireContainer<C>(this);
  }
  @override
  void dispose() {
    Injector.of(context).releaseContainer<C>(this);
    super.dispose();
  }
}