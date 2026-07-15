import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/food_item.dart';

class CartProvider extends ChangeNotifier {
  static const double deliveryFee = 4.99;
  static const double taxRate = 0.08;
  static const String validPromoCode = 'FINEDINE20';

  final List<CartItem> _items = [];
  String _promoCode = '';
  double _discountPercent = 0;

  List<CartItem> get items => List.unmodifiable(_items);
  String get promoCode => _promoCode;
  double get discountPercent => _discountPercent;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * _discountPercent;

  double get taxAmount => (subtotal - discountAmount) * taxRate;

  double get totalPrice {
    if (_items.isEmpty) return 0;
    return subtotal - discountAmount + deliveryFee + taxAmount;
  }

  bool isInCart(String foodId) =>
      _items.any((item) => item.foodItem.id == foodId);

  int quantityOf(String foodId) {
    final item = _items.where((i) => i.foodItem.id == foodId);
    return item.isEmpty ? 0 : item.first.quantity;
  }

  void addItem(FoodItem foodItem) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItem.id);
    if (index >= 0) {
      _items[index] =
          _items[index].copyWith(quantity: _items[index].quantity + 1);
    } else {
      _items.add(CartItem(foodItem: foodItem, quantity: 1));
    }
    notifyListeners();
  }

  void setItemQuantity(FoodItem foodItem, int quantity) {
    if (quantity <= 0) {
      removeItem(foodItem.id);
      return;
    }
    final index = _items.indexWhere((item) => item.foodItem.id == foodItem.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
    } else {
      _items.add(CartItem(foodItem: foodItem, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(String foodId, int quantity) {
    if (quantity <= 0) {
      removeItem(foodId);
      return;
    }
    final index = _items.indexWhere((item) => item.foodItem.id == foodId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void removeItem(String foodId) {
    _items.removeWhere((item) => item.foodItem.id == foodId);
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    if (code.trim().toUpperCase() == validPromoCode) {
      _promoCode = code.trim().toUpperCase();
      _discountPercent = 0.20;
      notifyListeners();
      return true;
    }
    return false;
  }

  void clearPromoCode() {
    _promoCode = '';
    _discountPercent = 0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    clearPromoCode();
    notifyListeners();
  }
}
