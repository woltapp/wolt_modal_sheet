// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _i1;
import 'package:widgetbook_workspace/src/view/widgets/orders_screen_content.dart'
    as _i3;
import 'package:widgetbook_workspace/src/button/wolt_elevated_button.dart'
    as _i2;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookFolder(
    name: 'button',
    children: [
      _i1.WidgetbookLeafComponent(
        name: 'WoltElevatedButton',
        useCase: _i1.WidgetbookUseCase(
          name: 'Primary',
          builder: _i2.primaryButton,
        ),
      )
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'features',
    children: [
      _i1.WidgetbookFolder(
        name: 'orders',
        children: [
          _i1.WidgetbookFolder(
            name: 'ui',
            children: [
              _i1.WidgetbookFolder(
                name: 'view',
                children: [
                  _i1.WidgetbookFolder(
                    name: 'widgets',
                    children: [
                      _i1.WidgetbookLeafComponent(
                        name: 'OrderScreenContent',
                        useCase: _i1.WidgetbookUseCase(
                          name: 'OrderScreenContent',
                          builder: _i3.orderScreenContent,
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          )
        ],
      )
    ],
  ),
];
