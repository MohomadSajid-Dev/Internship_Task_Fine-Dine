import 'package:flutter_test/flutter_test.dart';

import 'package:internship_task/data/food_repository.dart';
import 'package:internship_task/main.dart';
import 'package:internship_task/providers/cart_provider.dart';
import 'package:internship_task/providers/food_provider.dart';

void main() {
  testWidgets('App launches FINE DINE splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FineDineApp());
    await tester.pump();

    expect(find.text('FINE DINE'), findsOneWidget);
    expect(find.text('Every Meal is an Experience'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
  });

  test('Cart provider manages items and promo code', () async {
    final foodProvider = FoodProvider(FoodRepository());
    final cartProvider = CartProvider();

    await foodProvider.loadFoodItems();
    final foodItem = foodProvider.items.first;

    cartProvider.addItem(foodItem);
    expect(cartProvider.itemCount, 1);

    cartProvider.updateQuantity(foodItem.id, 2);
    expect(cartProvider.itemCount, 2);

    expect(cartProvider.applyPromoCode('FINEDINE20'), isTrue);
    expect(cartProvider.discountPercent, 0.20);

    cartProvider.removeItem(foodItem.id);
    expect(cartProvider.items, isEmpty);
  });
}
