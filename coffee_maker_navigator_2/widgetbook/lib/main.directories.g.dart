// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _i1;
import 'package:widgetbook_workspace/src/button/wolt_elevated_button.dart'
    as _i16;
import 'package:widgetbook_workspace/src/features/orders/view/modal_pages/grind/grind_or_reject_modal_page.dart'
    as _i2;
import 'package:widgetbook_workspace/src/features/orders/view/modal_pages/grind/reject_order_modal_page.dart'
    as _i3;
import 'package:widgetbook_workspace/src/features/orders/view/modal_pages/not_found/order_not_found_modal.dart'
    as _i4;
import 'package:widgetbook_workspace/src/features/orders/view/modal_pages/ready/extra_recommendation_tile.dart'
    as _i5;
import 'package:widgetbook_workspace/src/features/orders/view/modal_pages/ready/offer_recommendation_modal_page.dart'
    as _i6;
import 'package:widgetbook_workspace/src/features/orders/view/modal_pages/ready/serve_or_offer_modal_page.dart'
    as _i7;
import 'package:widgetbook_workspace/src/features/orders/view/widgets/coffee_order_list_item_tile.dart'
    as _i8;
import 'package:widgetbook_workspace/src/features/orders/view/widgets/coffee_order_list_view_for_step.dart'
    as _i9;
import 'package:widgetbook_workspace/src/features/orders/view/widgets/orders_screen_bottom_navigation_bar.dart'
    as _i11;
import 'package:widgetbook_workspace/src/features/orders/view/widgets/orders_screen_content.dart'
    as _i10;
import 'package:widgetbook_workspace/src/features/orders/widgets/coffee_maker_custom_divider.dart'
    as _i12;
import 'package:widgetbook_workspace/src/features/orders/widgets/grid_layout_button.dart'
    as _i13;
import 'package:widgetbook_workspace/src/features/orders/widgets/store_online_status_button.dart'
    as _i14;
import 'package:widgetbook_workspace/src/features/orders/widgets/top_bar.dart'
    as _i15;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookFolder(
    name: 'Orders',
    children: [
      _i1.WidgetbookFolder(
        name: 'View',
        children: [
          _i1.WidgetbookFolder(
            name: 'ModalPages',
            children: [
              _i1.WidgetbookFolder(
                name: 'Grind',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'GrindOrRejectModalPage',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'GrindOrRejectModalPage',
                      builder: _i2.grindOrRejectModalPage,
                    ),
                  ),
                  _i1.WidgetbookLeafComponent(
                    name: 'RejectOrderModalPage',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'RejectOrderModalPage',
                      builder: _i3.rejectOrderModalPage,
                    ),
                  ),
                ],
              ),
              _i1.WidgetbookFolder(
                name: 'NotFound',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'OrderNotFoundModal',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'OrderNotFoundModal',
                      builder: _i4.rejectOrderModalPage,
                    ),
                  )
                ],
              ),
              _i1.WidgetbookFolder(
                name: 'Ready',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'ExtraRecommendationTile',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'ExtraRecommendationTile',
                      builder: _i5.extraRecommendationTile,
                    ),
                  ),
                  _i1.WidgetbookLeafComponent(
                    name: 'OfferRecommendationModalPage',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'OfferRecommendationModalPage',
                      builder: _i6.offerRecommendationModalPage,
                    ),
                  ),
                  _i1.WidgetbookLeafComponent(
                    name: 'ServeOrOfferModalPage',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'ServeOrOfferModalPage',
                      builder: _i7.serveOrOfferModalPage,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _i1.WidgetbookFolder(
            name: 'Widgets',
            children: [
              _i1.WidgetbookLeafComponent(
                name: 'CoffeeOrderListItemTile',
                useCase: _i1.WidgetbookUseCase(
                  name: 'CoffeeOrderListItemTile',
                  builder: _i8.coffeeOrderListItemTile,
                ),
              ),
              _i1.WidgetbookLeafComponent(
                name: 'CoffeeOrderListViewForStep',
                useCase: _i1.WidgetbookUseCase(
                  name: 'CoffeeOrderListViewForStep',
                  builder: _i9.coffeeOrderListViewForStep,
                ),
              ),
              _i1.WidgetbookLeafComponent(
                name: 'OrderScreenContent',
                useCase: _i1.WidgetbookUseCase(
                  name: 'OrderScreenContent',
                  builder: _i10.orderScreenContent,
                ),
              ),
              _i1.WidgetbookComponent(
                name: 'OrdersScreenBottomNavigationBar',
                useCases: [
                  _i1.WidgetbookUseCase(
                    name: 'Empty',
                    builder: _i11.ordersScreenBottomNavigationBarEmpty,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Filled',
                    builder: _i11.ordersScreenBottomNavigationBarFilled,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'Widgets',
        children: [
          _i1.WidgetbookLeafComponent(
            name: 'CoffeeMakerCustomDivider',
            useCase: _i1.WidgetbookUseCase(
              name: 'CoffeeMakerCustomDivider',
              builder: _i12.coffeeMakerCustomDivider,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'GridLayoutButton',
            useCase: _i1.WidgetbookUseCase(
              name: 'GridLayoutButton',
              builder: _i13.gridLayoutButton,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'StoreOnlineStatusButton',
            useCase: _i1.WidgetbookUseCase(
              name: 'StoreOnlineStatusButton',
              builder: _i14.storeOnlineStatusButton,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'TopBar',
            useCase: _i1.WidgetbookUseCase(
              name: 'TopBar',
              builder: _i15.storeOnlineStatusButton,
            ),
          ),
        ],
      ),
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'button',
    children: [
      _i1.WidgetbookLeafComponent(
        name: 'WoltElevatedButton',
        useCase: _i1.WidgetbookUseCase(
          name: 'Primary',
          builder: _i16.primaryButton,
        ),
      )
    ],
  ),
];
