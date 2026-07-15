import 'food_item.dart';

class CartItem {
  const CartItem({
    required this.foodItem,
    required this.quantity,
  });

  final FoodItem foodItem;
  final int quantity;

  double get totalPrice => foodItem.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      foodItem: foodItem,
      quantity: quantity ?? this.quantity,
    );
  }
}
