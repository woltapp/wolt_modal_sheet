const String _imagePath = 'lib/assets/images/coffee_maker_state';

enum CoffeeMakerStep {
  grind(
    stepName: 'Grind',
    stepNumber: 0,
    actionName: 'Start grinding',
    assetName: '${_imagePath}_grind.jpg',
  ),
  addWater(
    stepName: 'Add water',
    stepNumber: 1,
    actionName: 'Add water',
    assetName: '${_imagePath}_water.jpg',
  ),
  ready(
    stepName: 'Ready',
    stepNumber: 2,
    actionName: 'Ready',
    assetName: '${_imagePath}_ready.jpg',
  );

  const CoffeeMakerStep({
    required this.stepName,
    required this.stepNumber,
    required this.actionName,
    required this.assetName,
  });

  final String stepName;
  final int stepNumber;
  final String actionName;
  final String assetName;
}
