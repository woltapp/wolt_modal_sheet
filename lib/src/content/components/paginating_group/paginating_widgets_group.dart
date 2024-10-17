import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/paginating_widgets_group.dart';

export 'main_content_animated_builder.dart';
export 'navigation_toolbar_animated_builder.dart';
export 'sab_animated_builder.dart';
export 'top_bar_animated_builder.dart';

class PaginatingWidgetsGroup {
  final MainContentAnimatedBuilder mainContentAnimatedBuilder;
  final TopBarAnimatedBuilder topBarAnimatedBuilder;
  final NavigationToolbarAnimatedBuilder navigationToolbarAnimatedBuilder;
  final SabAnimatedBuilder sabAnimatedBuilder;
  final Widget offstagedMainContent;

  const PaginatingWidgetsGroup({
    required this.mainContentAnimatedBuilder,
    required this.topBarAnimatedBuilder,
    required this.navigationToolbarAnimatedBuilder,
    required this.sabAnimatedBuilder,
    required this.offstagedMainContent,
  });
}
