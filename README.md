<p align="center">
    <a href="https://wolt.com/"><img src="https://img.shields.io/badge/Powered%20by-Wolt-blue.svg" alt="Wolt"></a>
    <a href="https://pub.dev/packages/wolt_modal_sheet/publisher"><img src="https://img.shields.io/pub/publisher/wolt_modal_sheet.svg" alt="Wolt on pub.dev"></a>
    <br>
    <a href="https://pub.dev/packages/wolt_modal_sheet"><img src="https://badgen.net/pub/flutter-platform/wolt_modal_sheet" alt="Platforms"></a>
    <br>
    <a href="https://pub.dev/packages/wolt_modal_sheet"><img src="https://img.shields.io/pub/v/wolt_modal_sheet?logo=dart&logoColor=white" alt="Pub Version"></a>
    <a href="https://pub.dev/packages/wolt_modal_sheet"><img src="https://badgen.net/pub/points/wolt_modal_sheet" alt="Pub points"></a>
    <a href="https://pub.dev/packages/wolt_modal_sheet"><img src="https://badgen.net/pub/likes/wolt_modal_sheet" alt="Pub Likes"></a>
    <a href="https://pub.dev/packages/wolt_modal_sheet"><img src="https://badgen.net/pub/popularity/wolt_modal_sheet" alt="Pub popularity"></a>
    <br>    
    <a href="https://github.com/woltapp/wolt_modal_sheet"><img src="https://img.shields.io/github/stars/woltapp/wolt_modal_sheet?style=social" alt="Repo stars"></a>
    <a href="https://github.com/woltapp/wolt_modal_sheet/pulls"><img src="https://img.shields.io/github/issues-pr/woltapp/wolt_modal_sheet" alt="Repo PRs"></a>
    <a href="https://github.com/woltapp/wolt_modal_sheet/issues?q=is%3Aissue+is%3Aopen"><img src="https://img.shields.io/github/issues/woltapp/wolt_modal_sheet" alt="Repo issues"></a>
    <a href="https://github.com/woltapp/wolt_modal_sheet/graphs/contributors"><img src="https://badgen.net/github/contributors/woltapp/wolt_modal_sheet" alt="Contributors"></a>
    <a href="https://github.com/woltapp/wolt_modal_sheet/blob/main/LICENSE"><img src="https://badgen.net/github/license/woltapp/wolt_modal_sheet" alt="License"></a>
    <br>       
    <a href="https://app.codecov.io/gh/woltapp/wolt_modal_sheet"><img src="https://img.shields.io/codecov/c/github/woltapp/wolt_modal_sheet?logo=codecov&logoColor=white" alt="Coverage Status"></a>
</p>

# WoltModalSheet

WoltModalSheet is designed to revolutionize the use of Flutter modal sheets.
Built with Wolt-grade design quality and used extensively
in [Wolt](https://wolt.com/) products, this UI component offers a visually
appealing and user-friendly modal sheet with multiple pages, motion animation
for page transitions, and scrollable content within each page.

- [Examples](#examples)
  * [Coffee Maker Example](#coffee-maker-example)
  * [Playground Example](#playground-example)
  * [Playground Navigator2 Example](#playground-navigator2-example)
  * [Coffee Maker Navigator2 Example](#coffee-maker-navigator2-example)
- [Features](#features)
  * [Multi-Page Layout](#multi-page-layout)
  * [Scrollable Content](#scrollable-content)
  * [Responsive Design](#responsive-design)
  * [Motion Animation](#motion-animation)
  * [Imperative and Declarative Navigation](#imperative-and-declarative-navigation)
  * [Dynamic Pagination](#dynamic-pagination)
  * [State Management Integration](#state-management-integration)
- [Design Guidelines](#design-guidelines)
  * [Overview](#overview)
  * [Breakpoints](#breakpoints)
    + [Modal Types](#modal-types)
  * [Safe Areas](#safe-areas)
    + [iOS](#ios)
    + [Android](#android)
  * [Scroll Logic](#scroll-logic)
    + [Scroll Logic Layouts](#scroll-logic-layouts)
  * [Modal Sheet Layouts](#modal-sheet-layouts)
    + [Alert](#alert)
    + [Dialog](#dialog)
    + [Side Sheet](#side-sheet)
    + [Bottom Sheet](#bottom-sheet)
    + [Full Bottom Sheet](#full-bottom-sheet)
  * [Design Considerations](#design-considerations)
  * [Example Implementations](#example-implementations)
    + [On Media Example](#on-media-example)
    + [Breakpoint Adaptation](#breakpoint-adaptation)
- [Understanding the page elements](#understanding-the-page-elements)
  * [Navigation bar widgets](#navigation-bar-widgets)
  * [Top bar and top bar title](#top-bar-and-top-bar-title)
  * [Sticky action bar (SAB)](#sticky-action-bar--sab-)
  * [Hero image](#hero-image)
  * [Page Title](#page-title)
  * [Main content](#main-content)
- [Designer's Collaboration Guide](#designer-s-collaboration-guide)
  * [What's Inside the Figma File](#what-s-inside-the-figma-file)
  * [Utilizing the Figma File](#utilizing-the-figma-file)
- [Customizable Animations](#customizable-animations)
  * [Default Animation Style Specifications](#default-animation-style-specifications)
    + [Pagination Animation](#pagination-animation)
    + [Scrolling Animation](#scrolling-animation)
  * [Example Configuration](#example-configuration)
- [Usage of WoltModalSheet Pages](#usage-of-woltmodalsheet-pages)
  * [SliverWoltModalSheetPage](#sliverwoltmodalsheetpage)
  * [WoltModalSheetPage](#woltmodalsheetpage)
  * [NonScrollingWoltModalSheetPage](#nonscrollingwoltmodalsheetpage)
  * [Choosing between the three](#choosing-between-the-three)
- [In-Modal Navigation](#in-modal-navigation)
  * [Managing Navigation Stack](#managing-navigation-stack)
    + [Adding Pages to the Stack](#adding-pages-to-the-stack)
    + [Modifying Existing Pages](#modifying-existing-pages)
      - [Replace a specific page](#replace-a-specific-page)
      - [Replace or update the current page](#replace-or-update-the-current-page)
      - [Remove a specific page](#remove-a-specific-page)
      - [Add or replace pages](#add-or-replace-pages)
  * [Navigation Between Pages](#navigation-between-pages)
    + [Direct navigation](#direct-navigation)
    + [Pushing Pages](#pushing-pages)
    + [Popping Page](#popping-page)
  * [Dynamic Navigation with ValueNotifiers](#dynamic-navigation-with-valuenotifiers)
    + [Navigation by Page Index Notifier](#navigation-by-page-index-notifier)
    + [Dynamic Page List Management by Page List Builder Notifier](#dynamic-page-list-management-by-page-list-builder-notifier)
- [Getting started](#getting-started)
- [CupertinoApp support](#cupertinoapp-support)
- [Usage](#usage)
  * [Example app](#example-app)
  * [Playground app with imperative navigation](#playground-app-with-imperative-navigation)
  * [Playground app with declarative navigation](#playground-app-with-declarative-navigation)
  * [Coffee maker app for state management example](#coffee-maker-app-for-state-management-example)
- [Additional information](#additional-information)

## Examples

You can review the usage examples of repository by clicking on the links.

### [Coffee Maker Example](https://coffeemakerexample.web.app)

### [Playground Example](https://playgroundwoltexample.web.app)

### [Playground Navigator2 Example](https://playgroundnavigator2woltexample.web.app)

### [Coffee Maker Navigator2 Example](https://coffeemakernavigator2.web.app)


## Features

### Multi-Page Layout

Traverse through numerous pages within a single sheet.

![Experience multi-page navigation in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_multi.gif?raw=true)

### Scrollable Content

Greater flexibility with scrollable content per page, accommodating large
content effortlessly.

![Scroll with ease in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_scrolling.gif?raw=true)

### Responsive Design

The modal sheet adjusts to fit all screen sizes, appearing as a dialog on larger
screens and as a bottom sheet on smaller screens, guided by user-specified
conditions.

![Adaptability to different screen sizes in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_responsive.gif?raw=true)

### Motion Animation

Engage users with dynamic motion animation for page transitions and scrolling.

| Pagination                                                                                                 | Scrolling                                                                                             |
| ---------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| ![Pagination](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_motion_pagination.gif?raw=true) | ![Scrolling](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_scroll_motion.gif?raw=true) |

### Imperative and Declarative Navigation

The library showcases examples of both imperative and declarative navigation
patterns to display modal sheet on screen.

![Illustration of imperative and declarative navigation in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_navigator_2.gif?raw=true)

### Dynamic Pagination

User input can dynamically shape the modal sheet's page list.

![Dynamic pagination in action in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_dynamic_pagination.gif?raw=true)

### State Management Integration

Pages in the Wolt Modal Sheet offer a customizable look and the page components
are provided with an instance of WoltModalSheetPage class. The API provides a
way
to manage the state among the page components to be used with popular libraries
such as Bloc and Provider
</br>
</br>

## Design Guidelines

This section outlines the design guidelines for the modal sheet component, including breakpoints, safe areas, scroll logic, and behavior across different devices. The guidelines are based on the Wolt design system specs.

### Overview

The modal sheet component is used to display critical information or interactive elements to users in a non-intrusive way. This component adapts to different screen sizes and orientations, ensuring a consistent and accessible user experience.

### Breakpoints

The modal sheet component adjusts its layout based on the following breakpoints:

- **Breakpoint Large**: Width ≥ 1400px
- **Breakpoint Medium**: 768px ≤ Width < 1400px
- **Breakpoint Small**: 524px ≤ Width < 768px
- **Breakpoint XSmall**: Width < 524px

<img width="1158" alt="Screenshot 2024-06-30 at 17 15 49" src="https://github.com/yarneo/wolt_modal_sheet/assets/4066863/7dd39e47-8045-45a5-b03b-c62da805bc5f">

#### Modal Types

- **Alert**: Used for critical information that requires immediate attention.
- **Dialog**: Used for single user actions or to convey information related to changes in state (success, errors).
- **Side Sheet**: Used to focus users' attention on a specific task while keeping the context visible.
- **Bottom Sheet**: Used for additional options or actions.
- **Full Bottom Sheet**: Used to present content that requires full screen height.

### Safe Areas
The Modal Sheet supports safe areas for all compatible devices. See below the safe area considerations.

#### iOS

1. **iPhone without Notch**:
    - Status Bar Height: 20 points
    - Safe Area Insets:
        - Top: 20 points
        - Bottom: 0 points (unless there's a home indicator)

2. **iPhone with Notch (iPhone X and later)**:
    - Status Bar Height: 44 points (varies with device)
    - Safe Area Insets:
        - Top: 44 points
        - Bottom: 34 points (home indicator area)

#### Android

1. **Standard Devices**:
    - Status Bar Height: Approximately 24 dp (varies with screen density and device)
    - Safe Area Insets:
        - Top: 24 dp (status bar)
        - Bottom: Varies (on-screen navigation bars, if any)

2. **Devices with Notch (Display Cutout)**:
    - Status Bar Height: Varies depending on the notch size
    - Safe Area Insets:
        - Top: Varies with notch (retrieved using DisplayCutout API)
        - Bottom: Varies (on-screen navigation bars, if any)

### Scroll Logic

The modal sheet component supports different scrolling behaviors to ensure usability and accessibility of the content:

- **Non-scrollable Modals**: For content that fits within the viewport, no scrolling is required. The entire modal content is visible without interaction.
- **Scrollable Modals**: When content exceeds the viewport height, the modal becomes scrollable. Users can scroll through the content while the modal's header and action buttons remain fixed for easy access.

#### Scroll Logic Layouts

- **Short Content**: Displayed fully within the viewport without scrolling.
- **Medium Content**: Scrolls vertically if the content exceeds the available height but keeps action buttons fixed at the bottom.
- **Long Content**: Utilizes full vertical scrolling. The header remains sticky at the top while action buttons are sticky at the bottom for continuous access.

### Modal Sheet Layouts

#### Alert
- Used to display information requiring immediate user attention.
- Adapts to different breakpoints to ensure visibility and accessibility.
- Must be dismissed by user interaction to ensure the alert is acknowledged.

#### Dialog
- Used for single user actions or state change information (success, errors).
- Scales with breakpoints to maintain usability.
- Provides clear actions for users to acknowledge or dismiss the dialog.

#### Side Sheet
- Used to focus users' attention on specific tasks while keeping context visible.
- Spans the full height of the viewport.
- Is modal and blocks other interactions until dismissed.

#### Bottom Sheet
- Provides additional options or actions without leaving the current context.
- Auto height adjustment for optimal content display.
- Can be modal or persistent. Modal bottom sheets are dismissed by a user action, while persistent ones remain until manually dismissed.

#### Full Bottom Sheet
- Utilized for content that requires full screen height.
- Appears as an overlay, occupying the entire vertical viewport.
- Ideal for complex tasks that require more space and user attention.

### Design Considerations

- **Accessibility**: Ensure all modal sheets are accessible by supporting screen readers and keyboard navigation. It is important to add close affordances either as a close button in the navigation bar and an additional screen reader close affordance as part of the scrim (grayed area).
- **Visibility**: Modals have a clear visual distinction from the background to ensure they are easily noticeable.
- **Responsiveness**: Modals adapt seamlessly to different screen sizes and orientations.

### Example Implementations

#### On Media Example
- Modals should be translucent, ensuring the background remains visible to provide context.

#### Breakpoint Adaptation
- Modals adapt to various breakpoints seamlessly to maintain usability and accessibility across different devices and screen sizes.

<img width="1379" alt="Screenshot 2024-06-30 at 15 17 13" src="https://github.com/yarneo/wolt_modal_sheet/assets/4066863/239abe11-f5e5-4bea-8fd6-41857ff3229e">

## Understanding the page elements

Each element within the WoltModalSheet has a role to play, offering context,
navigational assistance, and explicit action prompts to the user. By
understanding these elements and their roles, you can fully harness the power of
WoltModalSheet and create an intuitive and engaging user experience.

The structure is organized across layers on the z-axis:

<li><b>Main Content Layer</b>: The fundamental content of the page,
including the optional page title, optional hero image, and the main content,
which may be scrollable.</li>
<li><b>Top Bar Layer</b>: Further above the main content layer, this layer
with the filled color includes the top bar title and may become hidden or
sticky based on scroll position and specific properties.</li>
<li><b>Navigation Bar Layer</b>: Sitting at the top of the top bar layer on
z-axis, this transparent-background layer contains navigational widgets for
the interface, such as back or close buttons.</li>
<li><b>Sticky Action Bar Layer</b>: Positioned at the top of the z axis,
this layer guides the user towards the next step, uses an optional gentle
gradient on top to hint that there is more content below ready for scrolling.</li>
</br>

![Modal sheet page layers](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/modal_sheet_page.png?raw=true)
</br>

By employing these various layers, you can create an interactive and visually
appealing interface that resonates with users. Each layer contributes to the
overall coherence of the page, serving a specific purpose and enhancing the
overall user experience.
</br>

![Modal sheet elements breakdown](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/bottom_sheet_elements.jpeg?raw=true)

### Navigation bar widgets

The navigation bar has a transparent background, and resides at the top of
the sheet, situated directly above the top bar on the z-axis. It includes
two specific widgets: the leading and the trailing. The leading widget
usually functions as the back button, enabling users to navigate to the
previous page. The trailing widget often serves as the close button, utilized to
close the modal sheet. The middle area is reserved and left empty for the
visibility of the top bar title.
</br>
</br>
The navigation bar widgets provide clear and intuitive navigational control,
differentiating themselves from the top bar by focusing specifically on
directional navigation within the interface.

### Top bar and top bar title

The top bar layer sits above the main content layer and below the navigation
bar layer in z axis. It helps users grasping the context by displaying an
optional title. In scenarios where the sheet is filled with content
requiring scrolling, the top bar becomes visible as the user scrolls, and
replaces the page title. At this point, the top bar adopts a 'sticky'
position at the top, guaranteeing consistent visibility.
</br>
</br>
The top bar widget has a flexible design. When `hasTopBarLayer` is set to
false, the top bar and the top bar title will not be shown. If
`isTopBarLayerAlwaysVisible` set to true, the top bar will be always visible
regardless of the scroll position.
</br>
</br>
A custom top bar widget can be provided using the `topBar` field. In this
case, the `topBarTitle` field will be ignored, and will not be displayed.
</br>
</br>
The navigation bar widgets overlay above the top bar, and when the default
top bar widget is used in the page, the top bar title is symmetrically
framed between the leading and trailing navigation bar widgets.

### Sticky action bar (SAB)

The Sticky Action Bar (SAB) guides the user towards the next step. Anchored to
the bottom of the view, the SAB elevates above the content with an optional
gentle gradient. This position guarantees that the action remains visible, subtly
hinting to the user that there is more content to be explored below the fold
by scrolling.

### Hero image

An optional Hero Image can be positioned at the top of the main content. This
element immediately grabs the user's attention, effectively conveying the
primary theme or message of the content.

### Page Title

An optional page title above the main content provides users with a quick
understanding of what to expect from the page. As the user scrolls, this title
becomes hidden, at which point the top bar title continues to serve this
context-providing purpose.

### Main content

The main content delivers information according to the user need. It can be
scrollable to handle larger content. The content is built lazily to improve the
performance.

Here is an example that shows all the modal sheet elements in use:

![Modal sheet elements in use](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/bottom_sheet_example.jpeg?raw=true)

## Designer's Collaboration Guide

To ensure seamless collaboration between designers and developers, we have 
provided a [Figma file](https://www.figma.com/file/jRQUhvi44bkUxRxSWGhSXO/Wolt-Modal-Sheet-Specs?type=design&node-id=7%3A514&mode=design&t=NULXGTxl2YvnawyH-1) dedicated to the WoltModalSheet package. This resource aims to guide designers through the process of creating and handing over designs that leverage the WoltModalSheet's capabilities effectively.

### What's Inside the Figma File

- **Example Design Specifications**: Detailed design guidelines and 
  specifications mirroring those used internally at Wolt. These specs 
  illustrate how to prepare designs for development handoff, ensuring a 
  smooth transition from design to implementation.

- **Modal Types Specifications**: This section showcases specifications for 
  different modal types, including dialog and bottom sheet modals. It covers 
  essential details like dimensions, layout of elements, and visual 
  arrangements, providing clear instructions for replicating these styles in 
  your projects.

- **Motion Animation Specs for Modal Interactions**: To complement the 
  static design aspects, this section demonstrates motion animation 
  specifications for pagination and scrolling interactions. It includes 
  guidelines for animating transitions between modal sheet pages and within 
  the content scroll, enabling designers to specify dynamic, engaging user 
  experiences.

### Utilizing the Figma File

By integrating this Figma file into your design process, you can:

- **Align on Design Language**: Ensure that your application's design 
  language and the modal sheet's functionality are in harmony, providing a 
  consistent user experience.

- **Facilitate Design Handoff**: Use the provided specifications as a 
  reference point for design handoff, minimizing misunderstandings and 
  streamlining the development process.

- **Inspire Creative Solutions**: Leverage the examples and specifications 
  as a source of inspiration for implementing innovative design solutions.

## Customizable Animations

Developers can customize the page scrolling and pagination animations by
providing an instance of  `WoltModalSheetAnimationStyle` class to 
`WoltModalSheetThemeData`.

### Default Animation Style Specifications

#### Pagination Animation

![Modal sheet elements in use](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/pagination_modal_sheet.png?raw=true)

#### Scrolling Animation

![Modal sheet elements in use](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/scrolling_modal_sheet.png?raw=true)

### Example Configuration

```dart
WoltModalSheetThemeData(
  animationStyle: WoltModalSheetAnimationStyle(
    paginationAnimationStyle: WoltModalSheetPaginationAnimationStyle(
      mainContentIncomingOpacityCurve: const Interval(
        150 / 350,
        350 / 350,
        curve: Curves.linear,
      ),
      modalSheetHeightTransitionCurve: const Interval(
        0 / 350,
        300 / 350,
        curve: Curves.fastOutSlowIn,
      ),
      incomingSabOpacityCurve: const Interval(
        100 / 350,
        300 / 350,
        curve: Curves.linear,
      ),
      // Define additional pagination animation styles as needed.
    ),
    scrollAnimationStyle: WoltModalSheetScrollAnimationStyle(
      heroImageScaleStart: 1.0,
      heroImageScaleEnd: 0.9,
      topBarTitleTranslationYInPixels: 8.0,
      topBarTranslationYInPixels: 4.0,
      // Define additional scroll animation styles as needed.
    ),
  ),
),
```

## Usage of WoltModalSheet Pages

The WoltModalSheet library provides three primary classes for constructing 
modal sheet pages: `WoltModalSheetPage`, `SliverWoltModalSheetPage`, and 
`NonScrollingWoltModalSheetPage`. Understanding the use cases and 
functionalities of these classes is key to creating performant, 
easy-to-construct modal sheets.

### SliverWoltModalSheetPage

`SliverWoltModalSheetPage` is designed for complex and dynamic content 
layouts within a modal sheet. It leverages the power of Flutter's Sliver 
widgets to provide flexible and efficient scrolling behaviors.

```dart
SliverWoltModalSheetPage(
  mainContentSliversBuilder: (context) => [
    SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        // Your list items
      }),
    ),
    // Other sliver widgets...
  ],
  // Additional page elements like pageTitle, topBarTitle, etc.
)
```

### WoltModalSheetPage

WoltModalSheetPage provides a simpler alternative for pages that primarily 
consist of a single widget or a straightforward layout. It automatically 
wraps the child widget in a SliverToBoxAdapter, making it suitable for use 
in sliver-based scrollable layouts.

Key Features:
* Simplicity: Ideal for single-widget content or basic layouts.
* No Sliver Overhead: Automatically handles the wrapping of non-sliver 
  widgets into slivers.
* Ease of Use: Simplifies the process of creating modal sheet pages without 
  needing to deal with slivers directly.

 ```dart
WoltModalSheetPage(
  child: MyCustomContentWidget(),
  pageTitle: Text('My Page Title'),
  // Other properties...
)
 ```

### NonScrollingWoltModalSheetPage

`NonScrollingWoltModalSheetPage` is designed to display content which is 
flexible in height but unlikely to require scrolling. This class is ideal 
for content that adapts to the available vertical space within the modal 
sheet's maximum height, but is unlikely to exceed that height and require 
scrolling.

Key Features:
* Adaptability: Designed for content with flexible height but fixed or 
intrinsic dimensions.
* Flex Layout: Can utilize the Flex layout model of a Column for effective 
  space management.
* Non-Scrolling: Best for content that fits within the modal sheet's maximum 
  height without needing scrolling.

*Warning:* If there is a risk that the content's height might exceed the modal 
sheet's maximum height, leading to overflow, it is recommended to use 
SliverWoltModalSheetPage or WoltModalSheetPage instead. These classes 
provide scrolling capabilities to handle larger content effectively using 
slivers.

 ```dart
NonScrollingWoltModalSheetPage(
  child: MyFlexibleHeightWidget(),
  // Additional properties...
)

 ```

This class extends SliverWoltModalSheetPage, offering a streamlined approach 
to handle non-scrolling content within a modal sheet.

### Choosing between the three
When deciding which class to use for your modal sheet, consider the following guidelines:

* WoltModalSheetPage: Choose this for simpler content layouts, especially 
  when working with a single widget. It's best suited for straightforward 
  layouts that don't require the complexities of Slivers.

* SliverWoltModalSheetPage: Opt for this class when your modal sheet
  requires complex scrolling behaviors or needs to display a long list of
  items. It's ideal for dynamic content layouts that benefit from the advanced
  capabilities of Flutter's Sliver widgets.

* NonScrollingWoltModalSheetPage: This class is best when your content is 
  flexible in height but unlikely to require scrolling. It’s perfect for 
  modal sheets where the content fits within the modal's maximum height 
  without the need for scrollable behavior. Use this for content with fixed 
  or intrinsic dimensions that need to adapt to available vertical space.

## In-Modal Navigation

The package provides in-modal navigation capabilities, allowing for dynamic 
transitions and stack manipulations directly within the modal. This section 
details how to utilize these features effectively in your applications.

### Managing Navigation Stack

he following methods facilitate the addition, removal, and modification of 
pages within the navigation stack. These functionalities allow you to 
dynamically adapt the navigation stack based on user interactions without 
disrupting the currently displayed page.

#### Adding Pages to the Stack

You can append one or more pages to the navigation stack. This feature is 
particularly useful for preloading pages or preparing navigation paths for 
future steps without changing the currently displayed page.

```dart
WoltModalSheet.of(context).addPages([newPage1, newPage2, newPage3]);
WoltModalSheet.of(context).addPage(newPage1);
```

#### Modifying Existing Pages

These methods allow you to replace or remove specific pages within the stack.
If the page being modified is currently visible, appropriate adjustments are 
made to ensure seamless navigation.

##### Replace a specific page
When you need to update or change the content of a specific page within the 
stack, this method allows you to replace any page by its identifier without 
altering the rest of the stack.
    
```dart
WoltModalSheet.of(context).replacePage(pageId, newPage);
```

##### Replace or update the current page

When the current page needs to be removed from the page list and replaced by 
a new page, with a pagination animation at the same position in the list, 
use `replaceCurrentPage` method.

```dart
WoltModalSheet.of(context).replaceCurrentPage(newPage);
```

When the overall context or the purpose of the current page is still 
relevant, but you need to modify specific attributes of the current page, use 
`updateCurrentPage` method.

```dart
WoltModalSheet.of(context).updateCurrentPage((currentPage) {
  return currentPage.copyWith(
    enableDrag: true,
    hasTopBarLayer: false,
    // Other updated properties...
  );
});
```

##### Remove a specific page
This method enables you to selectively remove a page from the navigation 
stack using its identifier. If the page being removed is the currently 
displayed page, it will remove the page and adjust the currently displayed page 
accordingly. If it is not the current page, it is removed from the stack 
without impacting the current view.

```dart
WoltModalSheet.of(context).removePage(pageId);
```

##### Add or replace pages
This method updates the navigation stack by either adding new pages or 
replacing all subsequent pages depending on the position of the current page.
If the current page is the last in the stack it simply appends the new pages.
However, if the current page is not the last, it replaces all pages 
following it with the new ones. This functionality is particularly useful 
for adapting the user's navigation path dynamically based on their 
interactions with the currently displayed page or when making adjustments to 
previously made decisions.

```dart
WoltModalSheet.of(context).addOrReplacePages([newPage1, newPage2, newPage3]);
WoltModalSheet.of(context).addOrReplacePage(newPage);
```

### Navigation Between Pages

This subsection details the methods for moving within the modal's navigation 
stack, allowing users to navigate through pages effectively.

#### Direct navigation
Navigate within the modal stack using specific methods to move directly to a 
desired page. You can go to the next or previous page, jump to a page at a 
specific index in the page list, or navigate to a page by its unique identifier.

```dart
// Move to the next page
bool movedNext = WoltModalSheet.of(context).showNext();

// Move to the previous page
bool movedPrevious = WoltModalSheet.of(context).showPrevious();

// Jump directly to a page at a specific index
bool navigatedByIndex = WoltModalSheet.of(context).showAtIndex(2);

// Navigate to a page by its unique identifier
bool navigatedById = WoltModalSheet.of(context).showPageWithId(pageId);
```

#### Pushing Pages
Using push methods, you can add one or more new pages to the end of the 
navigation stack and navigate to the first of the newly added pages.

```dart
WoltModalSheet.of(context).pushPages([newPage1, newPage2, newPage3]);
WoltModalSheet.of(context).pushPage(newPage);
```

#### Popping Page
Using pop method, you can remove the last page of the navigation stack. If the
user is on the last page, the method will navigate to the previous page.
    
```dart
bool popped = WoltModalSheet.of(context).pop();
```

### Dynamic Navigation with ValueNotifiers
`ValueNotifier<int> pageIndexNotifier` and 
`ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier` can 
also be utilized for in-modal navigation and setting the modal navigation 
stack. These notifiers dynamically manage the visible page index 
and the page list, enhancing flexibility in response to the state changes.

#### Navigation by Page Index Notifier
`ValueNotifier<int> pageIndexNotifier` controls the visible page index, 
enabling transitions between pages based on user interactions or other events.

```dart
// Example of setting up a modal with navigation between pages controlled by 
// a ValueNotifier<int>.
final pageIndexNotifier = ValueNotifier(0); // Initializes the page index

WoltModalSheet.show(
  context: context,
  pageListBuilder: (modalSheetContext) => [
    PageOne(onNextButtonPressed: () => pageIndexNotifier.value = 1),
    PageTwo(onBackButtonPressed: () => pageIndexNotifier.value = pageIndexNotifier.value - 1),
  ],
  pageIndexNotifier: pageIndexNotifier,  // Tracks and updates the displayed page
);

```

#### Dynamic Page List Management by Page List Builder Notifier
`ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier` 
manages updates to the modal's page list based on user interactions or other 
app state changes. This is useful when implementing Navigator 2.0 for 
declarative navigation scenarios. It is not suggested to mix the usage of 
this notifier with the imperative navigation methods provided by the package.

```dart
final pageIndexNotifier = ValueNotifier(0); // Initializes the page index
final pageListBuilderNotifier = ValueNotifier((context) => [
  PageOne(onNextButtonPressed: () => pageIndexNotifier.value++),
  PageTwo(onBackButtonPressed: () => pageIndexNotifier.value--),
]);

WoltModalSheet.showWithDynamicPath(
  context: context,
  pageListBuilderNotifier: pageListBuilderNotifier,
  pageIndexNotifier: pageIndexNotifier,  // Dynamically updates the navigation stack
);
```


## Getting started

To use this plugin, add wolt_modal_sheet as a dependency in your pubspec.yaml
file.

## CupertinoApp support

In the package, certain Material widgets rely on retrieving Material localizations information
from the widget tree. However, Material localizations are not inherently available in CupertinoApp,
leading to potential errors. To mitigate this issue, if your application utilizes CupertinoApp
rather than MaterialApp, it is needed to incorporate a default Material localization delegate
into your application configuration.

```dart
CupertinoApp(
  localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
    DefaultMaterialLocalizations.delegate,
],)
```
To see its usage, please check [coffee maker example app](coffee_maker/lib/main.dart).

## Usage

This package has 4 example projects.

### Example app

The [example](./example/) app demonstrates how to display a two-pages modal
sheet that can be customized for dark and light themes
using [WoltModalSheetThemeData](./lib/src/theme/wolt_modal_sheet_theme_data.dart) theme
extension.

```dart
@override
Widget build(BuildContext context) {
  final pageIndexNotifier = ValueNotifier(0);

  SliverWoltModalSheetPage page1(BuildContext modalSheetContext, TextTheme textTheme) {
    return WoltModalSheetPage(
      hasSabGradient: false,
      stickyActionBar: Padding(
        padding: const EdgeInsets.all(_pagePadding),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: Navigator.of(modalSheetContext).pop,
              child: const SizedBox(
                height: _buttonHeight,
                width: double.infinity,
                child: Center(child: Text('Cancel')),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: WoltModalSheet.of(modalSheetContext).showNext,
              child: const SizedBox(
                height: _buttonHeight,
                width: double.infinity,
                child: Center(child: Text('Next page')),
              ),
            ),
          ],
        ),
      ),
      topBarTitle: Text('Pagination', style: textTheme.titleSmall),
      isTopBarLayerAlwaysVisible: true,
      trailingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(_pagePadding),
        icon: const Icon(Icons.close),
        onPressed: Navigator.of(modalSheetContext).pop,
      ),
      child: const Padding(
              padding: EdgeInsets.fromLTRB(
                _pagePadding,
                _pagePadding,
                _pagePadding,
                _bottomPaddingForButton,
              ),
              child: Text(
                '''
Pagination involves a sequence of screens the user navigates sequentially. We chose a lateral motion for these transitions. When proceeding forward, the next screen emerges from the right; moving backward, the screen reverts to its original position. We felt that sliding the next screen entirely from the right could be overly distracting. As a result, we decided to move and fade in the next page using 30% of the modal side.
''',
              )),
    );
  }

  SliverWoltModalSheetPage page2(BuildContext modalSheetContext, TextTheme textTheme) {
    return SliverWoltModalSheetPage(
      pageTitle: Padding(
        padding: const EdgeInsets.all(_pagePadding),
        child: Text(
          'Material Colors',
          style: textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      heroImage: Image(
        image: NetworkImage(
          'https://raw.githubusercontent.com/woltapp/wolt_modal_sheet/main/example/lib/assets/images/material_colors_hero${_isLightTheme ? '_light' : '_dark'}.png',
        ),
        fit: BoxFit.cover,
      ),
      leadingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(_pagePadding),
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: WoltModalSheet.of(modalSheetContext).showPrevious,
      ),
      trailingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(_pagePadding),
        icon: const Icon(Icons.close),
        onPressed: Navigator.of(modalSheetContext).pop,
      ),
      mainContentSliversBuilder: (context) => [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 2.0,
          ),
          delegate: SliverChildBuilderDelegate(
                    (_, index) => ColorTile(color: materialColorsInGrid[index]),
            childCount: materialColorsInGrid.length,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                    (_, index) => ColorTile(color: materialColorsInSliverList[index]),
            childCount: materialColorsInSliverList.length,
          ),
        ),
      ],
    );
  }

  return MaterialApp(
    themeMode: _isLightTheme ? ThemeMode.light : ThemeMode.dark,
    theme: ThemeData.light(useMaterial3: true).copyWith(
      extensions: const <ThemeExtension>[
        WoltModalSheetThemeData(
          heroImageHeight: _heroImageHeight,
          topBarShadowColor: _lightThemeShadowColor,
          modalBarrierColor: Colors.black54,
          mainContentScrollPhysics: ClampingScrollPhysics(),
        ),
      ],
    ),
    darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
      extensions: const <ThemeExtension>[
        WoltModalSheetThemeData(
          topBarShadowColor: _darkThemeShadowColor,
          modalBarrierColor: Colors.white12,
          sabGradientColor: _darkSabGradientColor,
          dialogShape: BeveledRectangleBorder(),
          bottomSheetShape: BeveledRectangleBorder(),
          mainContentScrollPhysics: ClampingScrollPhysics(),
        ),
      ],
    ),
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(...),
              ElevatedButton(
                onPressed: () {
                  WoltModalSheet.show<void>(
                    context: context,
                    pageListBuilder: (modalSheetContext) {
                      final textTheme = Theme.of(context).textTheme;
                      return [
                        page1(modalSheetContext, textTheme),
                        page2(modalSheetContext, textTheme),
                      ];
                    },
                    modalTypeBuilder: (context) {
                      final size = MediaQuery.sizeOf(context).width;
                      if (size < _pageBreakpoint) {
                        return WoltModalType.bottomSheet;
                      } else {
                        return WoltModalType.dialog;
                      }
                    },
                    onModalDismissedWithBarrierTap: () {
                      debugPrint('Closed modal sheet with barrier tap');
                      Navigator.of(context).pop();
                    },
                    maxDialogWidth: 560,
                    minDialogWidth: 400,
                    minPageHeight: 0.0,
                    maxPageHeight: 0.9,
                  );
                },
                child: const SizedBox(
                  height: _buttonHeight,
                  width: _buttonWidth,
                  child: Center(child: Text('Show Modal Sheet')),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
```

The code snippet above produces the following:
</br>
</br>

![Example app](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/example_wms_demo.gif?raw=true)

### Playground app with imperative navigation

The [playground](./playground/) app demonstrates how to imperatively show the
modal sheet. The purpose of this module is to play and experiment with various
use cases.

### Playground app with declarative navigation

The [playground_navigator2](./playground_navigator2/) has the same content with
the [playground](./playground/) app but the modal sheet is shown using Navigator
2.0 (Router API) in a declarative way.

### Coffee maker app for state management example

Finally, the [coffee_maker](./coffee_maker/) app demonstrates how to manage the
state among the page components with an opinionated use of the Provider state
management library.

The code snippet demonstrates how to decorate the modal sheet with a change
notifier provider so that the page components can be rebuilt according to the
current state:

```dart
  void _onCoffeeOrderSelectedInAddWaterState(
      BuildContext context, String coffeeOrderId) {
    final model = context.read<StoreOnlineViewModel>();

    WoltModalSheet.show(
      context: context,
      decorator: (child) {
        return ChangeNotifierProvider<StoreOnlineViewModel>.value(
          value: model,
          builder: (_, __) => child,
        );
      },
      pageListBuilder: (context) {
        return [
          AddWaterDescriptionModalPage.build(coffeeOrderId),
          WaterSettingsModalPage.build(coffeeOrderId)
        ];
      },
      modalTypeBuilder: _modalTypeBuilder,
    );
  }
```

![Dynamic pagination in action in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_coffee_maker.gif?raw=true)

## Additional information

* <b>Design Philosophy</b>: Dive into the creative thought process behind
  WoltModalSheet's
  functionality [in our blog post](https://careers.wolt.com/en/blog/engineering/an-overview-of-the-multi-page-scrollable-bottom-sheet-ui-design)
  . Explore how we tackled the
  design challenges to create an intuitive and responsive
  experience.
* <b>Insights from FlutterCon'23
  talk</b>: We delved into both the design and developmental facets of this
  package at the FlutterCon'23 conference. Catch the
  enlightening [recording of his talk](https://www.droidcon.com/2023/08/07/the-art-of-responsive-modals-building-a-multi-page-sheet-in-flutter/)
  to understand the nuances.
* <b>Flutter&Friends talk</b>: This is a lightening talk given at the
  Flutter&Friends conference on September'23. It covers the design
  guidelines and best practices by showing real-world examples highlighting
  what to do—and what not to do. It also covers the technical details of the
  implementation. The recording of the talk can be found [here](https://www.youtube.com/live/X3bw1pr1kyQ?si=1SielcIbW6rF-4IC&t=4449).
