import 'package:flutter/material.dart';

/// Motion animation styles for both pagination and scrolling within a Wolt Modal Sheet.
///
/// This class serves as a configuration for the motion animations used within Wolt Modal Sheet.
/// It combines both pagination and scroll-related animations, allowing for a unified approach to
/// defining the visual transitions that occur during user interactions with the modal sheet.
///
/// Properties:
/// - `paginationAnimationStyle`: Defines the animation styles for transitions between pages
/// within the modal sheet. This includes animations for the main content's height, slide
/// positions, and opacity transitions for components like the navigation toolbar and top bar. It
/// allows for fine-tuned control over how these transitions appear and feel to the user,
/// enhancing the pagination experience.
/// - `scrollAnimationStyle`: Specifies the animation styles for scroll interactions within the
/// modal sheet. This can include dynamic effects such as scaling or fading of images, adjustment
/// of top bar visibility, and other scroll-driven animations. These settings allow for a more
/// interactive and engaging user experience as content is explored by scrolling within the modal
/// sheet.
///
/// Example:
/// ```
/// WoltModalSheetAnimationStyle(
///   paginationAnimationStyle: WoltModalSheetPaginationAnimationStyle(
///     // Custom pagination animation configurations
///   ),
///   scrollAnimationStyle: WoltModalSheetScrollAnimationStyle(
///     // Custom scroll animation configurations
///   ),
/// )
/// ```
class WoltModalSheetAnimationStyle {
  final WoltModalSheetPaginationAnimationStyle paginationAnimationStyle;
  final WoltModalSheetScrollAnimationStyle scrollAnimationStyle;

  const WoltModalSheetAnimationStyle({
    this.paginationAnimationStyle =
        const WoltModalSheetPaginationAnimationStyle(),
    this.scrollAnimationStyle = const WoltModalSheetScrollAnimationStyle(),
  });
}

/// Defines the animation styles for scrolling within Wolt Modal Sheet when the top bar component
/// of the modal sheet is set to enable becoming visible as the user scrolls.
///
/// Defines the customizable animation parameters for the hero image, top bar, and top bar title
/// within the modal sheet. These parameters control how these elements transform and fade in
/// response to scroll events as the top bar component of the modal sheet becomes visible.
class WoltModalSheetScrollAnimationStyle {
  /// The starting scale of the hero image when the modal sheet is at its initial
  /// scroll position. Default is 1.0, meaning no scaling.
  final double heroImageScaleStart;

  /// The ending scale of the hero image when the modal sheet has been scrolled
  /// to a certain point. Default value of 1.0 means the image will remain at its
  /// original size.
  final double heroImageScaleEnd;

  /// The starting opacity of the hero image. Default is 1.0, fully opaque.
  final double heroImageOpacityStart;

  /// The ending opacity of the hero image as the modal sheet is scrolled. Default is 0.0,
  ///which means fully transparent.
  final double heroImageOpacityEnd;

  /// The total vertical translation (in pixels) of the top bar.
  final double topBarTranslationYInPixels;

  /// The starting opacity of the top bar, with 0.0 being fully transparent
  /// and typically used to initially hide the bar before scrolling starts and it fades in.
  final double topBarOpacityStart;

  /// The ending opacity of the top bar, where 1.0 means fully opaque and
  /// typically used to fully reveal the bar as it is scrolled into view.
  final double topBarOpacityEnd;

  /// The total vertical translation (in pixels) of the top bar title.
  final double topBarTitleTranslationYInPixels;

  /// The starting opacity of the top bar title, with 0.0 being fully transparent.
  /// This allows the title to fade in from a transparent state as the modal sheet
  /// is scrolled.
  final double topBarTitleOpacityStart;

  /// The ending opacity of the top bar title, with 1.0 being fully opaque.
  /// This is typically used to ensure the title is fully visible once the top bar
  /// has been scrolled into its final position.
  final double topBarTitleOpacityEnd;

  /// Constructs a [WoltModalSheetScrollAnimationStyle] with customizable animation
  /// parameters for the hero image, top bar, and top bar title as the top bar becomes visible
  /// according to the scroll changes. Default values are provided, but can be overridden to
  /// achieve custom animation effects.
  ///
  /// Parameters allow for the specification of start/end scales and opacities for
  /// the hero image, and y translations and opacities for both the top bar
  /// and the top bar title.
  const WoltModalSheetScrollAnimationStyle({
    this.heroImageScaleStart = 1.0,
    this.heroImageScaleEnd = 1.0,
    this.heroImageOpacityStart = 1.0,
    this.heroImageOpacityEnd = 0.0,
    this.topBarTranslationYInPixels = 4.0,
    this.topBarOpacityStart = 0,
    this.topBarOpacityEnd = 1,
    this.topBarTitleTranslationYInPixels = 8.0,
    this.topBarTitleOpacityStart = 0,
    this.topBarTitleOpacityEnd = 1,
  });
}

/// Defines the animation styles for pagination transitions within Wolt Modal Sheet.
///
/// This class provides customization for animations triggered during page changes in a
/// multi-page modal sheet. It allows detailed customization of animation aspects for modal sheet
/// height adjustments, slide positions of the main content, and opacity transitions for various
/// components such as the navigation toolbar, sticky action button (SAB), and top bar. By
/// utilizing customizable animation curves, users can precisely control the timing and behavior of
/// these animations to customize transitions between pages within the modal sheet.
///
/// Animations defined in this class are triggered during pagination, which occurs when the modal
/// sheet changes from one page to another. These animations include:
/// - Modal sheet height transitions: Adjusts the height of the modal sheet to fit the content of
/// the incoming page so that during the transition both incoming and outgoing pages have the
/// same height.
/// - Main content slide transitions: Moves the main content horizontally or vertically, creating
/// a seamless transition effect during the transition.
/// - Opacity transitions for components: Fades in or out specific components (navigation
/// toolbar, SAB, top bar).
///
/// By adjusting the provided animation curves, developers can create custom animations that
/// align with the overall design language of their application.

class WoltModalSheetPaginationAnimationStyle {
  /// Curve for animating the height transition of the modal sheet height during pagination. The
  /// height of the modal sheet is always equal to the height of the main content, and this curve
  /// controls how the height of the main content's of both the incoming and outgoing pages
  /// changes. During the transition, the height of the both incoming and outgoing pages are equal.
  final Curve modalSheetHeightTransitionCurve;

  /// Curve for the slide position animation of the main content when it is incoming.
  /// Defines the motion trajectory for entering content.
  final Curve mainContentIncomingSlidePositionCurve;

  /// Curve for the slide position animation of the main content when it is outgoing.
  /// Defines the motion trajectory for exiting content.
  final Curve mainContentOutgoingSlidePositionCurve;

  /// Curve for the opacity animation of the main content when incoming.
  /// Controls how the opacity of entering main content changes, making it appear smoothly.
  final Curve mainContentIncomingOpacityCurve;

  /// Curve for the opacity animation of the main content when outgoing.
  /// Controls how the opacity of exiting main content changes, making it disappear smoothly.
  final Curve mainContentOutgoingOpacityCurve;

  /// Curve for animating the opacity of the navigation toolbar when incoming.
  /// This curve controls how the toolbar fades in as the page transitions in.
  final Curve incomingNavigationToolbarOpacityCurve;

  /// Curve for animating the opacity of the navigation toolbar when outgoing.
  /// Controls the fade-out effect of the toolbar as the page transitions out.
  final Curve outgoingNavigationToolbarOpacityInterval;

  /// Curve for the opacity animation of the sticky action button (SAB) when incoming.
  /// Defines how the SAB fades in during the page transition.
  final Curve incomingSabOpacityCurve;

  /// Curve for the opacity animation of the sticky action button (SAB) when outgoing.
  /// Defines how the SAB fades out during the page transition.
  final Curve outgoingSabOpacityCurve;

  /// Curve for the opacity animation of the top bar when incoming.
  /// Controls the fade-in effect of the top bar as the page transitions in.
  final Curve incomingTopBarOpacityCurve;

  /// Curve for the opacity animation of the top bar when outgoing.
  /// Controls the fade-out effect of the top bar as the page transitions out.
  final Curve outgoingTopBarOpacityCurve;

  /// The beginning offset for the slide animation of the main content when it is incoming.
  /// Allows specifying a custom start position, impacting how the content enters the view.
  final Offset? incomingMainContentSlideBeginOffset;

  /// The ending offset for the slide animation of the main content when it is incoming.
  /// Determines the final position of the entering content.
  final Offset incomingMainContentSlideEndOffset;

  /// The beginning offset for the slide animation of the main content when it is outgoing.
  /// Specifies the start position of the content as it begins to exit the view.
  final Offset outgoingMainContentSlideBeginOffset;

  /// The ending offset for the slide animation of the main content when it is outgoing.
  /// Determines the final off-screen position of the exiting content, controlling its exit trajectory.
  final Offset? outgoingMainContentSlideEndOffset;

  /// Constructs a [WoltModalSheetPaginationAnimationStyle] with customizable animation curves
  /// and offsets for different components during page transitions. Allows for detailed control
  /// over the appearance and behavior of modal sheet pagination animations, enabling developers
  /// to create smooth, visually appealing transitions.
  ///
  /// Default values for curves and offsets are provided, but all can be overridden to achieve
  /// custom animation effects tailored to specific design requirements.
  const WoltModalSheetPaginationAnimationStyle({
    this.incomingMainContentSlideBeginOffset,
    this.incomingMainContentSlideEndOffset = Offset.zero,
    this.outgoingMainContentSlideBeginOffset = Offset.zero,
    this.outgoingMainContentSlideEndOffset,
    this.modalSheetHeightTransitionCurve = const Interval(
      0 / 350,
      300 / 350,
      curve: Curves.fastOutSlowIn,
    ),
    this.mainContentIncomingSlidePositionCurve = const Interval(
      50 / 350,
      350 / 350,
      curve: Curves.fastOutSlowIn,
    ),
    this.mainContentOutgoingSlidePositionCurve = const Interval(
      50 / 350,
      350 / 350,
      curve: Curves.fastOutSlowIn,
    ),
    this.mainContentIncomingOpacityCurve = const Interval(
      150 / 350,
      350 / 350,
      curve: Curves.linear,
    ),
    this.mainContentOutgoingOpacityCurve = const Interval(
      50 / 350,
      150 / 350,
      curve: Curves.linear,
    ),
    this.incomingNavigationToolbarOpacityCurve = const Interval(
      100 / 350,
      300 / 350,
      curve: Curves.linear,
    ),
    this.outgoingNavigationToolbarOpacityInterval = const Interval(
      0,
      100 / 350,
      curve: Curves.linear,
    ),
    this.incomingSabOpacityCurve = const Interval(
      100 / 350,
      300 / 350,
      curve: Curves.linear,
    ),
    this.outgoingSabOpacityCurve = const Interval(
      0,
      100 / 350,
      curve: Curves.linear,
    ),
    this.incomingTopBarOpacityCurve = const Interval(
      150 / 350,
      350 / 350,
      curve: Curves.linear,
    ),
    this.outgoingTopBarOpacityCurve = const Interval(
      0,
      150 / 350,
      curve: Curves.linear,
    ),
  });
}
