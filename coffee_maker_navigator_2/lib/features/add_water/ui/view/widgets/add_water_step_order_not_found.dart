import 'package:coffee_maker_navigator_2/utils/extensions/context_extensions.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class AddWaterStepOrderNotFound extends StatelessWidget {
  const AddWaterStepOrderNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('lib/assets/images/order_not_found.webp'),
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Order not found. Please check the order id and make sure that the order is in the correct state.',
                  ),
                ),
              ),
              WoltElevatedButton(
                onPressed: context.routerViewModel.onAddWaterStepCompleted,
                child: const Text('Go to orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
