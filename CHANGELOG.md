## 0.6.0
- Fix navigator_2_playground_example by Use static value notifier for button enabled listener. [#216](https://github.com/woltapp/wolt_modal_sheet/pull/216)
- Add coffee maker navigator 2 example to Firebase Deploy. [#214](https://github.com/woltapp/wolt_modal_sheet/pull/214)
- Refactor updateCurrentPage method and introduce easy page update. [#213](https://github.com/woltapp/wolt_modal_sheet/pull/213)
- Update `wolt_modal_sheet_test.dart` tests. [#212](https://github.com/woltapp/wolt_modal_sheet/pull/212)
  - Fixes:
    - [#211](https://github.com/woltapp/wolt_modal_sheet/issues/211) Prepare repository for tests requirement
- Add Coffee Maker Demo App example with navigator 2.0 (Flutter Full Stack Conference). [#209](https://github.com/woltapp/wolt_modal_sheet/pull/209)
- Remove duplicate methods of WoltModalSheet. [#208](https://github.com/woltapp/wolt_modal_sheet/pull/208)
  - Fixes:
    - [#202](https://github.com/woltapp/wolt_modal_sheet/issues/202) add getter for `atRoot`
- Introduce updateCurrentPage method to update the currently visible page without pagination animation. [#207](https://github.com/woltapp/wolt_modal_sheet/pull/207)
  - Fixes:
    - [#205](https://github.com/woltapp/wolt_modal_sheet/issues/205) Dynamic Page Properties don't work
- Expose Page index getter. [#204](https://github.com/woltapp/wolt_modal_sheet/pull/204)
  - Fixes:
    - [#202](https://github.com/woltapp/wolt_modal_sheet/issues/202) add getter for `atRoot`
- fix: only decorate the content of the modal. [#203](https://github.com/woltapp/wolt_modal_sheet/pull/203)
  - Fixes:
    - [#201](https://github.com/woltapp/wolt_modal_sheet/issues/201) The child provided to decorator functions is larger than it should be
- Update readme. [#197](https://github.com/woltapp/wolt_modal_sheet/pull/197)
- Update PR deployment method. [#195](https://github.com/woltapp/wolt_modal_sheet/pull/195)
- Update PR checks. [#192](https://github.com/woltapp/wolt_modal_sheet/pull/192)
  - Fixes:
    - [#190](https://github.com/woltapp/wolt_modal_sheet/issues/190) Add PR check for tests
- Add tests PR check and improve existing checks. [#191](https://github.com/woltapp/wolt_modal_sheet/pull/191)
  - Fixes:
    - [#190](https://github.com/woltapp/wolt_modal_sheet/issues/190) Add PR check for tests
- Add Enhanced Navigation Methods to WoltModalSheet. [#188](https://github.com/woltapp/wolt_modal_sheet/pull/188)
- Bump minimum Flutter version to `3.10.6` and update Melos docs. [#187](https://github.com/woltapp/wolt_modal_sheet/pull/187)
  - Fixes:
    - [#183](https://github.com/woltapp/wolt_modal_sheet/issues/183) Bump minimum Flutter version required to `3.10.6`
- Add Controller. [#179](https://github.com/woltapp/wolt_modal_sheet/pull/179)
- Add mainContentSliversBuilder Property and Deprecation mainContentSlivers. [#177](https://github.com/woltapp/wolt_modal_sheet/pull/177)
  - Fixes:
    - [#176](https://github.com/woltapp/wolt_modal_sheet/issues/176) Expose mainContentSlivers's enclosing context
- Add "Table of Contents" to `README.md`. [#175](https://github.com/woltapp/wolt_modal_sheet/pull/175)
  - Fixes:
    - [#174](https://github.com/woltapp/wolt_modal_sheet/issues/174) Include a "Table of Contents" in README
## 0.5.0
- Added a "Designer's Collaboration Guide" section to the README, including 
  a Figma file link for streamlined design handoff and enhanced 
  collaboration between designers and developers. [#166](https://github.com/woltapp/wolt_modal_sheet/pull/166)
- Update example app files for missing RunnerTests folder and Podfile. [#168](https://github.com/woltapp/wolt_modal_sheet/pull/168)
  - Fixes [#153](https://github.com/woltapp/wolt_modal_sheet/issues/153)
- Introduce `WoltModalSheetAnimationStyle` to customize the pagination and 
  scrolling animation styles of the modal sheet. [#165](https://github.com/woltapp/wolt_modal_sheet/pull/165)
  - Addresses the issues: 
    - [#125](https://github.com/woltapp/wolt_modal_sheet/issues/125)
    - [#131](https://github.com/woltapp/wolt_modal_sheet/issues/131)
- Change default clip behavior to antiAliasWithSaveLayer to fix Top Bar 
  rendering issues. [#164](https://github.com/woltapp/wolt_modal_sheet/pull/164)
  - Fixes [#162](https://github.com/woltapp/wolt_modal_sheet/issues/162)
- Add resizeToAvoidBottomInset option to control soft keyboard overlay 
  behavior. [#163](https://github.com/woltapp/wolt_modal_sheet/pull/163)
  - Fixes [#154](https://github.com/woltapp/wolt_modal_sheet/issues/154)
- Add firebase hosting and deploy workflow so that every time PR is opened, 
  the samples will be deployed and sent as a message, and every time the 
  main is merged, the main samples will be deployed again. [#159](https://github.com/woltapp/wolt_modal_sheet/pull/159)
- The surfaceTintColor field is added to pages to control background color 
  of the modal sheet for every page. [#156](https://github.com/woltapp/wolt_modal_sheet/pull/156)
  - Addresses [#139](https://github.com/woltapp/wolt_modal_sheet/issues/139)
- Added semantics for improved accessibility of the modal sheet. [#150](https://github.com/woltapp/wolt_modal_sheet/pull/150)
  - Addresses [#148](https://github.com/woltapp/wolt_modal_sheet/issues/148) 

## 0.4.1
- Reverts [#128](https://github.com/woltapp/wolt_modal_sheet/pull/128) to fix [#134](https://github.com/woltapp/wolt_modal_sheet/issues/134) and [#135](https://github.com/woltapp/wolt_modal_sheet/issues/135)

## 0.4.0
- Fix state update handling: Current page do not receive update for new 
  widget subtree in the page when the decorator marks the page as dirty. 
  [#128](https://github.com/woltapp/wolt_modal_sheet/pull/128)
- Add NonScrollingWoltModalSheetPage page type. [#127](https://github.com/woltapp/wolt_modal_sheet/pull/127)

## 0.3.0
- Convert MaterialApp example app to CupertinoApp. [#120](https://github.com/woltapp/wolt_modal_sheet/pull/120)
- Fix RangeError on the SheetPageWithLazyList of the playground_navigator2 [#118](https://github.com/woltapp/wolt_modal_sheet/pull/118)
- Fix 'No MaterialLocalizations found' exception for Cupertino apps [#116](https://github.com/woltapp/wolt_modal_sheet/pull/116)
- **BREAKING CHANGE**:
  - Fix TopBar Widget keeps being visible after Keyboard hides. [#119](https://github.com/woltapp/wolt_modal_sheet/pull/119)
  - This fix, adds a new dependency to the package and requires minimum 6.0.0 of flutter_keyboard_visibility package if this package is used in your project with lower version than 6.0.0.


## 0.2.0
- Update readme for breaking changes. [#114](https://github.com/woltapp/wolt_modal_sheet/pull/114)
- Fix overflow scroll effect visibility when top bar is always visible. [#104](https://github.com/woltapp/wolt_modal_sheet/pull/104)
- Remove custom scroll behavior, allow scroll physics customization, fix double scroll effects and double scroll bars. [#103](https://github.com/woltapp/wolt_modal_sheet/pull/103)
- Add feature request and issue templates. [#101](https://github.com/woltapp/wolt_modal_sheet/pull/101)
- Add PR template. [#100](https://github.com/woltapp/wolt_modal_sheet/pull/100)
- Move contribution steps to its own file. [#98](https://github.com/woltapp/wolt_modal_sheet/pull/98)
- Use super for constructor parameters in WoltModalSheet page. [#97](https://github.com/woltapp/wolt_modal_sheet/pull/97)
- **BREAKING CHANGE**:
  - Introduce SliverWoltModalSheetPage and WoltModalSheetPage classes to construct modal sheet pages. [#95](https://github.com/woltapp/wolt_modal_sheet/pull/95)
  - Please follow [migration guide](https://github.com/woltapp/wolt_modal_sheet#migration-from-01x-to-020) if you are migrating from 0.1.x version.

## 0.1.4
- Chore: add badges to README.md. [#87](https://github.com/woltapp/wolt_modal_sheet/pull/87) by [Mikhail Zotyev @MbIXjkee](https://github.com/MbIXjkee)
- Add dart format check to merge check list. [#84](https://github.com/woltapp/wolt_modal_sheet/pull/84) by [Taha Tesser @TahaTesser](https://github.com/TahaTesser)
- Update the package & examples to support minimum Flutter v3.7.2 [#81](https://github.com/woltapp/wolt_modal_sheet/pull/81) by [Taha Tesser @TahaTesser](https://github.com/TahaTesser)
- Add the Flutter&Friends talk to the additional information section in  README.md. [#79](https://github.com/woltapp/wolt_modal_sheet/pull/79) by [Cagatay Ulusoy @ulusoyca](https://github.com/ulusoyca)
- Add contributing guide. [#81](https://github.com/woltapp/wolt_modal_sheet/pull/81) by [Taha Tesser @TahaTesser](https://github.com/TahaTesser)

## 0.1.3
- Add `melos` and cleanup `gitignore` and `pubspec.lock`. [#73](https://github.com/woltapp/wolt_modal_sheet/pull/73) Thanks to [@TahaTesser](https://github.com/TahaTesser)
- Allow custom top bar widget to be "not always visible". [#69](https://github.com/woltapp/wolt_modal_sheet/pull/69)
- Throw a helpful error message when returning an empty list in `pageListBuilder`. [#68](https://github.com/woltapp/wolt_modal_sheet/pull/68) Thanks to [@TahaTesser](https://github.com/TahaTesser)
- Refactoring Animated Builders used in pagination animation. [#65](https://github.com/woltapp/wolt_modal_sheet/pull/65)
- Added ability to use a custom widget as top bar. [#64](https://github.com/woltapp/wolt_modal_sheet/pull/64) Thanks to [@robyf](https://github.com/robyf)
- Remove extra scrollbars in the modal sheet due to nested scroll views. [#58](https://github.com/woltapp/wolt_modal_sheet/pull/58)
- Fix `barrierDismissible` parameter has no effect to prevent modal dismissing. [#56](https://github.com/woltapp/wolt_modal_sheet/pull/56)

## 0.1.2

- Documentation updates. [#54](https://github.com/woltapp/wolt_modal_sheet/pull/54)

## 0.1.1

- Documentation updates. [#53](https://github.com/woltapp/wolt_modal_sheet/pull/53)

## 0.1.0

- Remove unnecessary import and update example project's dependency version. [#52](https://github.com/woltapp/wolt_modal_sheet/pull/52)
- Add option to dynamically enable bottom sheet drag for a single page. [#45](https://github.com/woltapp/wolt_modal_sheet/pull/45)
- Add theme extensions for wolt modal sheet. [#44](https://github.com/woltapp/wolt_modal_sheet/pull/44)
- Enhancing Top Bar Configuration & Scroll Motion Animation. [#42](https://github.com/woltapp/wolt_modal_sheet/pull/42)
- Prevent the scroll offset from reaching beyond the bounds of the content in main scroll view. [#41](https://github.com/woltapp/wolt_modal_sheet/pull/41)
- Fix linter violations. [#39](https://github.com/woltapp/wolt_modal_sheet/pull/39)
- Add FlutterCon talk link to the ReadMe additional information. [#36](https://github.com/woltapp/wolt_modal_sheet/pull/36)
- Add some WoltModalSheet tests. [#35](https://github.com/woltapp/wolt_modal_sheet/pull/35) Thanks to [@TahaTesser](https://github.com/TahaTesser)
- Remove all dependencies from the example app. [#34](https://github.com/woltapp/wolt_modal_sheet/pull/34)
- Automation to mark PRs and issues as stale. [#32](https://github.com/woltapp/wolt_modal_sheet/pull/32)
- Refactor top bar and navigation control widgets. [#31](https://github.com/woltapp/wolt_modal_sheet/pull/31)
- Add an optional gradient over the sticky action bar. [#29](https://github.com/woltapp/wolt_modal_sheet/pull/29)
- Use page title text by default as source of the top bar title when top bar title is not provided. [#28](https://github.com/woltapp/wolt_modal_sheet/pull/28)
- Rework the changelog to show the latest update at the top. [#24](https://github.com/woltapp/wolt_modal_sheet/pull/24) Thanks to [@mkobuolys](https://github.com/mkobuolys)
- Added missing onModalDismissedWithDrag parameter in .show method. [#22](https://github.com/woltapp/wolt_modal_sheet/pull/22) Thanks to [@canbi](https://github.com/canbi)

## 0.0.4

- Fix repository link in pubspec file [#5](https://github.com/woltapp/wolt_modal_sheet/pull/5)
- Prevent horizontal scroll in the main content causing top bar motion [#13](https://github.com/woltapp/wolt_modal_sheet/pull/13)
- Make modal type builder optional by providing default breakpoint and modal type builder [#14](https://github.com/woltapp/wolt_modal_sheet/pull/14)
- Add callback for on modal dismiss with drag to be utilized in Navigator 2.0 [#15](https://github.com/woltapp/wolt_modal_sheet/pull/15)
- Rename page list builder notifier parameter for WoltModalSheet.show method [#16](https://github.com/woltapp/wolt_modal_sheet/pull/16)
- Scale hero image from center in HeroImageFlowDelegate [#17](https://github.com/woltapp/wolt_modal_sheet/pull/17)

## 0.0.3

- Fix broken gifs in ReadMe [#3](https://github.com/woltapp/wolt_modal_sheet/pull/3)

## 0.0.2

- Fix Readme

## 0.0.1

- Initial version.
