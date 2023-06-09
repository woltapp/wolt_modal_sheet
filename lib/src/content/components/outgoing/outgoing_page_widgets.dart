import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_footer_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_main_content_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_top_bar_widgets_animated_builder.dart';

export 'outgoing_footer_animated_builder.dart';
export 'outgoing_main_content_animated_builder.dart';
export 'outgoing_top_bar_widgets_animated_builder.dart';

class OutgoingPageWidgets {
  final OutgoingMainContentAnimatedBuilder mainContentAnimatedBuilder;
  final OutgoingTopBarWidgetsAnimatedBuilder topBarAnimatedBuilder;
  final OutgoingTopBarWidgetsAnimatedBuilder closeButtonAnimatedBuilder;
  final OutgoingTopBarWidgetsAnimatedBuilder backButtonButtonAnimatedBuilder;
  final OutgoingFooterAnimatedBuilder footerAnimatedBuilder;
  final Widget offstagedMainContent;

  OutgoingPageWidgets({
    required this.mainContentAnimatedBuilder,
    required this.topBarAnimatedBuilder,
    required this.closeButtonAnimatedBuilder,
    required this.backButtonButtonAnimatedBuilder,
    required this.footerAnimatedBuilder,
    required this.offstagedMainContent,
  });
}
