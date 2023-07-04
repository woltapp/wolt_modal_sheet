import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_main_content_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_sab_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_top_bar_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_top_bar_controls_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_main_content_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_sab_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_top_bar_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_top_bar_controls_animated_builder.dart';

export '../current/current_main_content_animated_builder.dart';
export '../current/current_sab_animated_builder.dart';
export '../current/current_top_bar_animated_builder.dart';
export '../outgoing/outgoing_main_content_animated_builder.dart';
export '../outgoing/outgoing_sab_animated_builder.dart';
export '../outgoing/outgoing_top_bar_animated_builder.dart';

abstract class PaginatingWidgetsGroup {
  final Widget mainContentAnimatedBuilder;
  final Widget topBarAnimatedBuilder;
  final Widget closeButtonAnimatedBuilder;
  final Widget backButtonButtonAnimatedBuilder;
  final Widget sabAnimatedBuilder;
  final Widget offstagedMainContent;

  PaginatingWidgetsGroup({
    required this.mainContentAnimatedBuilder,
    required this.topBarAnimatedBuilder,
    required this.closeButtonAnimatedBuilder,
    required this.backButtonButtonAnimatedBuilder,
    required this.sabAnimatedBuilder,
    required this.offstagedMainContent,
  });
}

class CurrentPageWidgets extends PaginatingWidgetsGroup {
  CurrentPageWidgets({
    required CurrentMainContentAnimatedBuilder super.mainContentAnimatedBuilder,
    required CurrentTopBarAnimatedBuilder super.topBarAnimatedBuilder,
    required CurrentTopBarControlsAnimatedBuilder super.closeButtonAnimatedBuilder,
    required CurrentTopBarControlsAnimatedBuilder super.backButtonButtonAnimatedBuilder,
    required CurrentSabAnimatedBuilder super.sabAnimatedBuilder,
    required super.offstagedMainContent,
  });
}

class OutgoingPageWidgets extends PaginatingWidgetsGroup {
  OutgoingPageWidgets({
    required OutgoingMainContentAnimatedBuilder super.mainContentAnimatedBuilder,
    required OutgoingTopBarAnimatedBuilder super.topBarAnimatedBuilder,
    required OutgoingTopBarControlsAnimatedBuilder super.closeButtonAnimatedBuilder,
    required OutgoingTopBarControlsAnimatedBuilder super.backButtonButtonAnimatedBuilder,
    required OutgoingSabAnimatedBuilder super.sabAnimatedBuilder,
    required super.offstagedMainContent,
  });
}
