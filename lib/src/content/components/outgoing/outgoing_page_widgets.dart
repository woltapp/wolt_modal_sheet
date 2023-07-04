import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_top_bar_controls_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_sab_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_main_content_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_top_bar_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_top_bar_controls_animated_builder.dart';

export 'outgoing_sab_animated_builder.dart';
export 'outgoing_main_content_animated_builder.dart';
export 'outgoing_top_bar_animated_builder.dart';

class OutgoingPageWidgets {
  final OutgoingMainContentAnimatedBuilder mainContentAnimatedBuilder;
  final OutgoingTopBarAnimatedBuilder topBarAnimatedBuilder;
  final OutgoingTopBarControlsAnimatedBuilder closeButtonAnimatedBuilder;
  final OutgoingTopBarControlsAnimatedBuilder backButtonButtonAnimatedBuilder;
  final OutgoingSabAnimatedBuilder sabAnimatedBuilder;
  final Widget offstagedMainContent;

  OutgoingPageWidgets({
    required this.mainContentAnimatedBuilder,
    required this.topBarAnimatedBuilder,
    required this.closeButtonAnimatedBuilder,
    required this.backButtonButtonAnimatedBuilder,
    required this.sabAnimatedBuilder,
    required this.offstagedMainContent,
  });
}
