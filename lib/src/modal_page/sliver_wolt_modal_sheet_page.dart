import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_hero_image.dart';
import 'package:wolt_modal_sheet/src/layout/header/modal_sheet_header.dart';
import 'package:wolt_modal_sheet/src/layout/wolt_modal_sheet_page_layout.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_theme_data.dart';
import 'package:wolt_modal_sheet/src/wolt_modal_sheet.dart';

/// The page classes are responsible for creating a modal sheet page within the context of the
/// [WoltModalSheet]. It's designed to represent a visually layered structure with clear
/// navigation and content display.
///
/// The structure is organized across layers on the z-axis:
/// 1. **Main Content Layer**: The fundamental content of the page, including the optional page
///    title, optional hero image, and the main content, which may be scrollable.
/// 2. **Top Bar Layer**: Further above the main content layer, this layer with the filled
///    color includes the top bar title and may become hidden or sticky based on scroll position
///    and specific properties.
/// 3. **Navigation Bar Layer**: Sitting at the top of the top bar layer on z-axis, this
///    transparent-background layer contains navigational widgets for the interface, such as back
///    or close buttons.
/// 4. **Sticky Action Bar Layer**: Positioned at the top of the z axis, this layer guides the
///    user towards the next step, uses an optional gentle gradient on top to hint that there is
///    more content below ready for scrolling.
///
/// By organizing these components across distinct layers, the class facilitates a clear and
/// intuitive user experience, with flexible customization options for various use cases.
///
/// [SliverWoltModalSheetPage] utilizes Flutter's sliver widgets for its main content,
/// built with [mainContentSliversBuilder]. Slivers are specialized Flutter widgets that
/// create elements with custom scroll effects and are a fundamental part of creating
/// advanced scrollable layouts.
///
/// The use of slivers in this context offers several key advantages:
///
/// 1. **Efficient On-Demand Rendering:**
///    Slivers render their items lazily, meaning they only build and render items that
///    are currently visible within the viewport. This approach is highly efficient for
///    scrollable lists or content areas with many items, as it optimizes both memory
///    usage and performance, especially for long or infinitely scrolling lists.
///
/// 2. **Custom Scroll Effects:**
///    Slivers enable the creation of custom scroll effects and behaviors. This is
///    particularly useful in the context of a modal sheet, where customized scrolling
///    behavior can enhance the user experience. For instance, parallax effects, sticky
///    headers, or collapsing toolbars can be seamlessly implemented using slivers.
///
/// 3. **Flexible Layout Structures:**
///    Slivers provide flexibility in layout design, allowing for dynamic arrangements of
///    components in a scrollable area. This flexibility is crucial for
///    [SliverWoltModalSheetPage] as it needs to adapt to various content structures and
///    user interactions within the modal sheet.
///
/// 4. **Integration with CustomScrollView:**
///    Using slivers allows `SliverWoltModalSheetPage` to integrate seamlessly with
///    `CustomScrollView`, a widget designed to create custom scroll effects with slivers.
class SliverWoltModalSheetPage extends StatefulWidget {
  /// An object representing the identity of this page.
  ///
  /// The [id] do not need to be unique among the pages. It's used to identify the page when
  /// navigating to a specific page or popping a page.
  final Object? id;

  /// Represents the widget that stands for the page title. A page title above the main content
  /// provides users with a quick understanding of what to expect from the page. As the user
  /// scrolls, this title becomes hidden, at which point the top bar title continues to serve
  /// this context-providing purpose.
  ///
  /// In many cases the text content for the [pageTitle] is the same as the text content in
  /// [topBarTitle]. Hence, when [topBarTitle] is not provided, the data of the first "Text" direct
  /// child of the of this widget will be used as the source for the [topBarTitle].
  ///
  /// A deeply nested text in the [pageTitle] widget can cause performance issues during the title
  /// retrieval process. Hence, it's recommended to keep the title text structure as simple as
  /// possible or explicitly provide the [topBarTitle] widget.
  final Widget? pageTitle;

  /// A [Widget] representing the title displayed in the top bar.
  ///
  /// When not provided, the data of the first "Text" direct child of the [pageTitle] widget will
  /// be used as the data for topBarTitle Text widget. If you want to avoid using the [pageTitle]
  /// text data, you should explicitly provide topBarTitle widget or set it as SizedBox.shrink().
  final Widget? topBarTitle;

  /// An optional [Widget] representing the top bar.
  ///
  /// When provided this widget will be used as the top bar instead of the default top bar. If
  /// this widget is provided, the [topBarTitle] will not be displayed. The height of this
  /// [topBar] should be set using the [navBarHeight] field.
  final Widget? topBar;

  /// On z axis, the Top Bar layer resides above the main content layer and below the transparent
  /// navigation bar layer.
  ///
  /// Top bar aids users in grasping the context by displaying an optional title. The height of
  /// the top bar is equal to the height of [navBarHeight]. In other saying, when visible,
  /// the top bar fills the transparent background of the navigation bar.
  ///
  /// In scenarios where sheets are filled with content requiring scrolling, by default the top
  /// bar becomes visible as the user scrolls, causing the page title replaced by the top bar. At
  /// this point, the top bar adopts a 'sticky' position at the top, guaranteeing consistent
  /// visibility. When [isTopBarLayerAlwaysVisible] is set to true, the top bar will be permanently
  /// sticky at the top of the sheet regardless of the scroll position.
  ///
  /// The Top Bar design is flexible, when [hasTopBarLayer] is set to false, the top bar and the
  /// [topBarTitle] will be hidden.
  final bool? hasTopBarLayer;

  /// Indicates whether the top bar should always remain visible, regardless of the page scroll
  /// position. When set to true, the top bar will be permanently displayed; when false, it may
  /// be hidden or revealed  based on the page's scrolling behavior.
  final bool? isTopBarLayerAlwaysVisible;

  /// Use this method to dynamically build the list of sliver widgets within the modal sheet
  /// based on the available [BuildContext]. This approach is more flexible and recommended
  /// for most use cases.
  final List<Widget> Function(BuildContext context) mainContentSliversBuilder;

  /// A [Widget] representing the hero image displayed on top of the main content. A Hero Image
  /// is positioned at the top of the main content. This widget immediately grabs the user's
  /// attention, effectively conveying the primary theme or message of the content.
  final Widget? heroImage;

  /// The height of the [heroImage].
  final double? heroImageHeight;

  /// The background color of the page.
  final Color? backgroundColor;

  /// The color of the surface tint overlay applied to the material color
  /// to indicate elevation for the modal sheet page. The [surfaceTintColor] is applied to the
  /// modal sheet background color, top bar color, and the sticky action bar wrapper colors.
  ///
  /// Material Design 3 introduced a new way for some components to indicate
  /// their elevation by using a surface tint color overlay on top of the
  /// base material [color]. This overlay is painted with an opacity that is
  /// related to the [elevation] of the material.
  ///
  /// If [ThemeData.useMaterial3] is false, then this property is not used.
  ///
  /// If [ThemeData.useMaterial3] is true and [surfaceTintColor] is not null and
  /// not [Colors.transparent], then it will be used to overlay the base [backgroundColor]
  /// with an opacity based on the [modalElevation].
  ///
  /// If [ThemeData.useMaterial3] is true and [surfaceTintColor] is null, then the default
  /// [surfaceTintColor] value is taken from the [ColorScheme].
  ///
  /// See also:
  ///
  ///   * [ThemeData.useMaterial3], which turns this feature on.
  ///   * [ElevationOverlay.applySurfaceTint], which is used to implement the
  ///     tint.
  ///   * https://m3.material.io/styles/color/the-color-system/color-roles
  ///     which specifies how the overlay is applied.
  final Color? surfaceTintColor;

  /// Height of the navigation bar. This value will also be the height of the top bar.
  ///
  /// The navigation bar layer has a transparent background, and sits directly above the top bar
  /// on the z-axis.
  ///
  /// It includes two specific widgets:
  /// the [leadingNavBarWidget] and the [trailingNavBarWidget]. The leading widget usually
  /// functions as the back button, enabling users to navigate to the previous page. The trailing
  /// widget often serves as the close button, utilized to close the modal sheet. Together, these
  /// widgets provide clear and intuitive navigational control, differentiating themselves from
  /// the top bar by focusing specifically on directional navigation within the interface.
  final double? navBarHeight;

  /// Indicates whether the page height should be at maximum even if the content size is smaller.
  final bool forceMaxHeight;

  /// A [ScrollController] that controls the scrolling behavior of the page.
  final ScrollController? scrollController;

  /// A widget representing the action widgets located at the bottom of the page.
  ///
  /// The Sticky Action Bar (SAB) guides the user towards the next step. Anchored to the bottom
  /// of the view, the SAB elevates above the content with a gentle gradient. This position
  /// guarantees that the action remains visible, subtly hinting to the user that there is more
  /// content to be explored below the fold.
  final Widget? stickyActionBar;

  /// Indicates whether a gentle gradient overlay should be rendered above the
  /// [stickyActionBar]. The purpose of this gradient is to visually suggest
  /// to the user that additional content might be present below the action bar.
  ///
  /// If set to `true`, a gradient from the [sabGradientColor] to transparent is rendered right
  /// above the [stickyActionBar]. If `false`, no gradient is rendered. By default, it's set to
  /// `true`.
  final bool? hasSabGradient;

  /// Controls the draggability of the bottom sheet. This setting overrides the value provided
  /// via [WoltModalSheet.show] specifically for this page when the modal is displayed as a bottom sheet.
  final bool? enableDrag;

  /// The color of the gentle gradient overlay that is rendered above the [stickyActionBar]. The
  /// purpose of this gradient is to visually suggest to the user that additional content might
  /// be present below the action bar.
  ///
  /// If [hasSabGradient] set to `true`, a gradient from this color to transparent is rendered
  /// right above the [stickyActionBar]. If `false`, no gradient is rendered. By default, it's
  /// value is to page background color.
  final Color? sabGradientColor;

  /// A widget representing leading widget in the navigation toolbar. This widget is usually
  /// a the back button.
  final Widget? leadingNavBarWidget;

  /// A widget representing trailing widget in the navigation toolbar. This widget is usually
  /// a the close button.
  final Widget? trailingNavBarWidget;

  /// If there is an onscreen keyboard displayed above the
  /// modal sheet, the main content can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the main content from being obscured by the keyboard.
  ///
  /// WoltModalSheet internally uses a [Scaffold] to provide this functionality and to handle the
  /// safe area color for the modal sheet. Setting this value will set the same value inside the
  /// internal [Scaffold] of the modal sheet.
  ///
  /// The default value is set in [WoltModalSheetDefaultThemeData.resizeToAvoidBottomInset].
  final bool? resizeToAvoidBottomInset;

  /// A boolean that determines whether the modal should avoid system UI intrusions such as the
  /// notch and system gesture areas.
  final bool? useSafeArea;

  /// Creates a page to be built within [WoltScrollableModalSheet].
  const SliverWoltModalSheetPage({
    super.key,
    required this.mainContentSliversBuilder,
    this.id,
    this.pageTitle,
    this.navBarHeight,
    this.topBarTitle,
    this.topBar,
    this.heroImage,
    this.heroImageHeight,
    this.backgroundColor,
    this.surfaceTintColor,
    this.hasSabGradient,
    this.enableDrag,
    this.sabGradientColor,
    this.forceMaxHeight = false,
    this.scrollController,
    this.stickyActionBar,
    this.leadingNavBarWidget,
    this.trailingNavBarWidget,
    this.hasTopBarLayer,
    this.isTopBarLayerAlwaysVisible,
    this.resizeToAvoidBottomInset,
    this.useSafeArea,
  }) : assert(!(topBar != null && hasTopBarLayer == false),
            "When topBar is provided, hasTopBarLayer must not be false");

  @override
  State<SliverWoltModalSheetPage> createState() => _SliverWoltModalSheetPageState();
}

class _SliverWoltModalSheetPageState extends State<SliverWoltModalSheetPage>
    with TickerProviderStateMixin {
  final _footerSizeDispatcher = ValueNotifier<double>(0);
  final GlobalKey _pageTitleKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final mainContentSlivers = widget.mainContentSliversBuilder(context);
    final backgroundColor =
        widget.backgroundColor ?? themeData?.backgroundColor ?? defaultThemeData.backgroundColor;

    return Material(
      color: backgroundColor,
      child: WoltModalSheetPageLayout(
        header: const ModalSheetHeader(child: SizedBox.shrink()),
        footer: widget.stickyActionBar,
        slivers: [_TopSlivers(page: widget), ...mainContentSlivers],
      ),
    );
  }
}

class _TopSlivers extends StatelessWidget {
  const _TopSlivers({super.key, required this.page});

  final SliverWoltModalSheetPage page;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);

    final heroImageHeight = page.heroImage == null
        ? 0.0
        : (page.heroImageHeight ?? themeData?.heroImageHeight ?? defaultThemeData.heroImageHeight);
    final pageHasTopBarLayer =
        page.hasTopBarLayer ?? themeData?.hasTopBarLayer ?? defaultThemeData.hasTopBarLayer;
    final isTopBarLayerAlwaysVisible =
        pageHasTopBarLayer && page.isTopBarLayerAlwaysVisible == true;
    final navBarHeight =
        page.navBarHeight ?? themeData?.navBarHeight ?? defaultThemeData.navBarHeight;
    final topBarHeight =
        pageHasTopBarLayer || page.leadingNavBarWidget != null || page.trailingNavBarWidget != null
            ? navBarHeight
            : 0.0;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            final heroImage = page.heroImage;
            return heroImage != null
                ? WoltModalSheetHeroImage(
                    topBarHeight: topBarHeight,
                    heroImage: heroImage,
                    heroImageHeight: heroImageHeight,
                    scrollAnimationStyle:
                        (themeData?.animationStyle ?? defaultThemeData.animationStyle)
                            .scrollAnimationStyle,
                  )
                // If top bar layer is always visible, the padding is explicitly added to the
                // scroll view since top bar will not be integrated to scroll view at all.
                // Otherwise, we implicitly create a spacing as a part of the scroll view.
                : SizedBox(
                    height: isTopBarLayerAlwaysVisible ? 0 : topBarHeight,
                  );
          }
          final pageTitle = page.pageTitle;
          return KeyedSubtree(
            // TODO(Cagatay): Add a key to the page title widget.
            // key: pageTitleKey,
            child: pageTitle ?? const SizedBox.shrink(),
          );
        },
        childCount: 2,
      ),
    );
  }
}
