import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_main_content_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_sab_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_top_bar_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_navigation_toolbar_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_main_content_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_sab_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_top_bar_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_navigation_toolbar_animated_builder.dart';

export '../current/current_main_content_animated_builder.dart';
export '../current/current_sab_animated_builder.dart';
export '../current/current_top_bar_animated_builder.dart';
export '../outgoing/outgoing_main_content_animated_builder.dart';
export '../outgoing/outgoing_sab_animated_builder.dart';
export '../outgoing/outgoing_top_bar_animated_builder.dart';

abstract class PaginatingWidgetsGroup {
  final Widget mainContentAnimatedBuilder;
  final Widget topBarAnimatedBuilder;
  final Widget navigationToolbarAnimatedBuilder;
  final Widget sabAnimatedBuilder;
  final Widget offstagedMainContent;

  PaginatingWidgetsGroup({
    required this.mainContentAnimatedBuilder,
    required this.topBarAnimatedBuilder,
    required this.navigationToolbarAnimatedBuilder,
    required this.sabAnimatedBuilder,
    required this.offstagedMainContent,
  });
}

class CurrentPageWidgets extends PaginatingWidgetsGroup {
  CurrentPageWidgets({
    required CurrentMainContentAnimatedBuilder super.mainContentAnimatedBuilder,
    required CurrentTopBarAnimatedBuilder super.topBarAnimatedBuilder,
    required CurrentNavigationToolbarAnimatedBuilder super.navigationToolbarAnimatedBuilder,
    required CurrentSabAnimatedBuilder super.sabAnimatedBuilder,
    required super.offstagedMainContent,
  });
}

class OutgoingPageWidgets extends PaginatingWidgetsGroup {
  OutgoingPageWidgets({
    required OutgoingMainContentAnimatedBuilder super.mainContentAnimatedBuilder,
    required OutgoingTopBarAnimatedBuilder super.topBarAnimatedBuilder,
    required OutgoingNavigationToolbarAnimatedBuilder super.navigationToolbarAnimatedBuilder,
    required OutgoingSabAnimatedBuilder super.sabAnimatedBuilder,
    required super.offstagedMainContent,
  });
}
