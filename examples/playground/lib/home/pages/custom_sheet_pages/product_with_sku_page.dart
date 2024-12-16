import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ProductWithSkuPage extends WoltModalSheetPage {
  final int sku;

  ProductWithSkuPage(this.sku)
      : super(
          heroImage: Stack(
            fit: StackFit.passthrough,
            children: [
              const Image(
                image: AssetImage('lib/assets/images/hero_image.jpg'),
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 30,
                bottom: 30,
                child: Center(child: ModalSheetTitle('SKU: $sku')),
              ),
            ],
          ),
          stickyActionBar: const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: WoltModalSheetCloseOrNextSab(),
          ),
          pageTitle: ModalSheetTitle('Product with sku $sku'),
          leadingNavBarWidget: const WoltModalSheetBackButton(),
          trailingNavBarWidget: const WoltModalSheetCloseButton(),
          child: const Padding(
            padding: EdgeInsets.only(bottom: 80, top: 16, left: 16, right: 16),
            child: ModalSheetContentText('''
Instead of relying on the order of pages or the id values provided to pages, we can also look pages up by type and any other arbitrary value that the page may have. This gives the user the power to address pages in ways that may not be covered by other options. 
'''),
          ),
        );
}
