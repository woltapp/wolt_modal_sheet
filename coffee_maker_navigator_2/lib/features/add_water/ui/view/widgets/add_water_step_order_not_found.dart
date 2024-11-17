import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class AddWaterStepOrderNotFound extends StatelessWidget {
  const AddWaterStepOrderNotFound({
    required this.onOrderStepCompleted,
    super.key,
  });

  final VoidCallback onOrderStepCompleted;

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
                image: AssetImage('assets/images/order_not_found.webp',
                    package: 'assets'),
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
                onPressed: onOrderStepCompleted,
                child: const Text('Go to orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
