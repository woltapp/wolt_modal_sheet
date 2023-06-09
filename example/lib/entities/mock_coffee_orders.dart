import 'package:example/entities/coffee_maker_step.dart';
import 'package:example/entities/coffee_order.dart';

/// A list of mock coffee orders used in the CoffeeMaker demo app.
const List<CoffeeOrder> mockCoffeeOrders = <CoffeeOrder>[
  CoffeeOrder(coffeeMakerStep: CoffeeMakerStep.grind, orderName: 'Yuho W.', id: '#001'),
  CoffeeOrder(coffeeMakerStep: CoffeeMakerStep.grind, orderName: 'John Doe', id: '#002'),
  CoffeeOrder(coffeeMakerStep: CoffeeMakerStep.grind, orderName: 'Jane Smith', id: '#003'),
  CoffeeOrder(coffeeMakerStep: CoffeeMakerStep.grind, orderName: 'Michael Johnson', id: '#004'),
  CoffeeOrder(coffeeMakerStep: CoffeeMakerStep.grind, orderName: 'Sarah Davis', id: '#005'),
  CoffeeOrder(coffeeMakerStep: CoffeeMakerStep.grind, orderName: 'David Wilson', id: '#006'),
  CoffeeOrder(coffeeMakerStep: CoffeeMakerStep.addWater, orderName: 'Emily Brown', id: '#007'),
  CoffeeOrder(coffeeMakerStep: CoffeeMakerStep.addWater, orderName: 'Robert Jones', id: '#008'),
  CoffeeOrder(coffeeMakerStep: CoffeeMakerStep.ready, orderName: 'Jennifer Taylor', id: '#009'),
];
