import 'package:equatable/equatable.dart';
import 'package:example/entities/coffee_maker_step.dart';

/// Represents a coffee order in the CoffeeMaker demo app.
class CoffeeOrder extends Equatable {
  /// The unique identifier of the coffee order.
  final String id;

  /// The current step of the coffee order in the coffee maker process.
  final CoffeeMakerStep coffeeMakerStep;

  /// The name of the person who placed the coffee order.
  final String orderName;

  /// Creates a new instance of [CoffeeOrder] with the specified properties.
  const CoffeeOrder({
    required this.id,
    required this.coffeeMakerStep,
    required this.orderName,
  });

  @override
  List<Object?> get props => [id, coffeeMakerStep, orderName];

  /// Creates a copy of the [CoffeeOrder] with updated properties.
  CoffeeOrder copyWith({
    String? id,
    CoffeeMakerStep? coffeeMakerStep,
    String? orderName,
  }) {
    return CoffeeOrder(
      id: id ?? this.id,
      coffeeMakerStep: coffeeMakerStep ?? this.coffeeMakerStep,
      orderName: orderName ?? this.orderName,
    );
  }
}
