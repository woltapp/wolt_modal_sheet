const String _imagePath = 'lib/assets/images/coffee_maker_state';

enum CoffeeMakerStep {
  grind(
      stepName: 'Grind',
      stepNumber: 0,
      actionName: 'Start grinding',
      assetName: '${_imagePath}_grind.jpg',
      tutorialTitle: 'Tips for grinding',
      queryParamName: 'grind',
      tutorialContent: '''
Grinding is crucial for brewing as it increases the surface area of coffee beans, enhancing water's ability to extract flavors effectively. However, the grind size needs to be optimal—not too fine nor too coarse—to prevent undesirable flavors from over- or under-extraction. Experts like Sierra Yeo emphasize that the right grind can significantly impact the taste of coffee, suggesting that coffee enthusiasts consider grinding their beans at home for the freshest, most flavorful results. Additionally, the consistency and shape of the coffee grounds also play critical roles in the brewing process, influencing the overall taste of the coffee.

The process of finding the perfect grind is not just about the size but also about how uniformly the coffee is ground. Uneven grinding can lead to a mixture of under-extracted (sour) and over-extracted (bitter) flavors in the final brew. For those looking to achieve barista-quality coffee at home, investing in a good quality grinder might be as crucial as the coffee maker itself. This allows for precise control over the grind size and uniformity, ensuring every cup of coffee is as delicious as intended. Over time, the ability to tweak grind settings based on the brewing method—whether French press, espresso, or drip—can transform a daily coffee routine into a gourmet experience, elevating the ordinary to the extraordinary.
'''),
  addWater(
    stepName: 'Add water',
    stepNumber: 1,
    actionName: 'Add water',
    assetName: '${_imagePath}_water.jpg',
    tutorialTitle: 'Adding water to coffee',
    queryParamName: 'water',
    tutorialContent: '''
Adding water to coffee involves precise considerations, significantly influencing the quality and flavor of the brew. Optimal water temperature, typically between 195°F to 205°F (about 90°C to 96°C), is crucial for effective extraction of coffee oils and flavors without causing bitterness due to over-extraction. These temperatures can vary slightly depending on the season, with adjustments made to accommodate ambient temperature effects on the brewing process. An innovative service class in the coffee maker takes these factors into account, dynamically adjusting acceptable temperature ranges based on the current coffee season to ensure optimal brewing conditions year-round.

Moreover, the quality of water used is paramount. The water source's pH level and hardness are critical factors; using water with inappropriate pH or high mineral content can significantly alter coffee's natural flavors. For example, the WaterSource enum provides structured choices—tap, filtered, or bottled water—with predefined pH and hardness levels, allowing users to select the most suitable option for their brewing needs. Tap water, with a pH of 7.5 and hardness of 3.5, may be suitable for general use, but for those seeking a more refined flavor, filtered water, with a lower pH of 7.0 and hardness of 2.0, might be more appropriate. Bottled water, offering the lowest hardness of 1.0 and a pH of 6.5, can be ideal for those looking to achieve the purest coffee taste. This nuanced approach, facilitated by the coffee maker's service class, ensures that each brew is crafted to highlight the best qualities of the coffee, allowing both casual drinkers and connoisseurs alike to enjoy a consistently superior coffee experience.
''',
  ),
  ready(
      stepName: 'Ready',
      stepNumber: 2,
      actionName: 'Ready',
      assetName: '${_imagePath}_ready.jpg',
      tutorialTitle: 'Serving coffee',
      queryParamName: 'ready',
      tutorialContent: '''
Serving coffee, the final and perhaps the most gratifying step in the coffee-making process, is about more than merely pouring a brew into a cup. This stage is crucial for ensuring that the aroma and temperature of the coffee are optimal at the moment of enjoyment. Serving coffee at the right temperature is vital—not too hot to cause discomfort, nor too cool, which might dampen its rich flavors and aromas. Ideally, coffee should be served immediately after brewing, at a temperature between 155°F and 175°F (about 68°C to 80°C), to capture the full spectrum of flavors crafted during the brewing process.

Additionally, the choice of serving vessel can significantly enhance the coffee-drinking experience. For instance, ceramic cups retain heat well and do not impart any additional flavors to the coffee, preserving its intended taste profile. In contrast, glass cups, while stylish, may lose heat more quickly but offer the visual pleasure of seeing the coffee's richness and color, which can be particularly appealing with layered drinks such as lattes or cappuccinos. Moreover, for those who take their coffee on the go, insulated travel mugs are an excellent choice to maintain the coffee’s temperature and flavor over time.

Further elevating the serving experience, some advanced coffee machines integrate serving suggestions based on the type of coffee being made—whether it's an espresso, a creamy latte, or a bold French press. These suggestions might include the ideal cup size, the recommended serving temperature, and even pairing advice with certain breakfast foods or desserts. This tailored approach ensures that each cup of coffee not only tastes great but also complements the setting and occasion, making every coffee moment truly special. This final touch in the coffee journey connects all the careful preparation steps to the sensory pleasure of drinking, making each sip a testament to the art and science of coffee making.
''');

  const CoffeeMakerStep({
    required this.stepName,
    required this.stepNumber,
    required this.actionName,
    required this.assetName,
    required this.tutorialContent,
    required this.tutorialTitle,
    required this.queryParamName,
  });

  final String stepName;
  final int stepNumber;
  final String actionName;
  final String assetName;
  final String tutorialContent;
  final String tutorialTitle;
  final String queryParamName;

  static CoffeeMakerStep fromQueryParameter(String queryParameter) {
    return CoffeeMakerStep.values.firstWhere(
      (element) => element.queryParamName == queryParameter,
      orElse: () => CoffeeMakerStep.grind,
    );
  }
}
