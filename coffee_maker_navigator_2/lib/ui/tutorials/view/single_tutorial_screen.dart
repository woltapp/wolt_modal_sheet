import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class SingleTutorialScreen extends StatelessWidget {
  const SingleTutorialScreen({super.key, required this.coffeeMakerStep});

  final CoffeeMakerStep coffeeMakerStep;

  @override
  Widget build(BuildContext context) {
    return SystemUIAnnotationWrapper(
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        const SizedBox(height: 200),
                        Image(
                          height: 200,
                          width: double.infinity,
                          image: AssetImage(coffeeMakerStep.assetName),
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coffeeMakerStep.tutorialTitle,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              coffeeMakerStep.tutorialContent,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: SafeArea(
                      child: BackButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: Navigator.of(context).pop,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
