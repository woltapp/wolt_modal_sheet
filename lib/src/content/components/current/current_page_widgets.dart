import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_sab_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_main_content_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_top_bar_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_top_bar_controls_animated_builder.dart';

export 'current_sab_animated_builder.dart';
export 'current_main_content_animated_builder.dart';
export 'current_top_bar_animated_builder.dart';

class CurrentPageWidgets {
  final CurrentMainContentAnimatedBuilder mainContentAnimatedBuilder;
  final CurrentTopBarAnimatedBuilder topBarAnimatedBuilder;
  final CurrentTopBarControlsAnimatedBuilder closeButtonAnimatedBuilder;
  final CurrentTopBarControlsAnimatedBuilder backButtonButtonAnimatedBuilder;
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
