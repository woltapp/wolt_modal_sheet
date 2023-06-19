import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_sab_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_main_content_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_top_bar_widgets_animated_builder.dart';

export 'current_sab_animated_builder.dart';
export 'current_main_content_animated_builder.dart';
export 'current_top_bar_widgets_animated_builder.dart';

class CurrentPageWidgets {
  final CurrentMainContentAnimatedBuilder mainContentAnimatedBuilder;
  final CurrentTopBarWidgetsAnimatedBuilder topBarAnimatedBuilder;
  final CurrentTopBarWidgetsAnimatedBuilder closeButtonAnimatedBuilder;
  final CurrentTopBarWidgetsAnimatedBuilder backButtonButtonAnimatedBuilder;
  final CurrentSabAnimatedBuilder sabAnimatedBuilder;
  final Widget offstagedMainContent;

  CurrentPageWidgets({
    required this.mainContentAnimatedBuilder,
    required this.topBarAnimatedBuilder,
    required this.closeButtonAnimatedBuilder,
    required this.backButtonButtonAnimatedBuilder,
    required this.sabAnimatedBuilder,
    required this.offstagedMainContent,
  });
}
