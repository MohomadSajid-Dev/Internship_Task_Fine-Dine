import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/food_image.dart';
import '../widgets/quantity_selector.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    this.embedded = false,
    this.onContinueShopping,
  });

  final bool embedded;
  final VoidCallback? onContinueShopping;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: widget.embedded
          ? null
          : AppBar(
              title: Text(
                'My Cart',
                style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: AppColors.cardWhite,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.charcoal, size: 16),
                  ),
                ),
              ),
            ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return _EmptyCart(
              embedded: widget.embedded,
              onContinue: () {
                if (widget.onContinueShopping != null) {
                  widget.onContinueShopping!();
                } else {
                  Navigator.pop(context);
                }
              },
            );
          }

          return Column(
            children: [
              if (widget.embedded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'My Cart',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.charcoal,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.espressoBrown.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(color: AppColors.softBeige.withValues(alpha: 0.5), width: 1),
                      ),
                      child: Row(
                        children: [
                          FoodImage(
                            imageUrl: item.foodItem.imageUrl,
                            width: 90,
                            height: 90,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.foodItem.name,
                                  style: GoogleFonts.playfairDisplay(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.charcoal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Rs. ${item.foodItem.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    color: AppColors.warmGold,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                QuantitySelector(
                                  compact: true,
                                  quantity: item.quantity,
                                  onDecrement: () => cart.updateQuantity(
                                    item.foodItem.id,
                                    item.quantity - 1,
                                  ),
                                  onIncrement: () => cart.updateQuantity(
                                    item.foodItem.id,
                                    item.quantity + 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => cart.removeItem(item.foodItem.id),
                                icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD32F2F), size: 22),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _OrderSummary(
                cart: cart,
                promoController: _promoController,
                onCheckout: () {
                  final total = cart.totalPrice;
                  final items = cart.itemCount;
                  cart.clearCart();
                  Navigator.pushNamed(
                    context,
                    AppRoutes.orderSuccess,
                    arguments: {'total': total, 'items': items},
                  );
                },
                onContinue: () {
                  if (widget.onContinueShopping != null) {
                    widget.onContinueShopping!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.embedded, required this.onContinue});

  final bool embedded;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.warmGold.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 72,
                color: AppColors.warmGold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Cart is Empty',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Discover our fine dining selection and add items to experience true culinary perfection.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 54,
              width: 220,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.espressoBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Continue Shopping',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.cart,
    required this.promoController,
    required this.onCheckout,
    required this.onContinue,
  });

  final CartProvider cart;
  final TextEditingController promoController;
  final VoidCallback onCheckout;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.espressoBrown.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Promo Code Input
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.espressoBrown.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: promoController,
                      style: GoogleFonts.inter(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Promo Code',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        filled: true,
                        fillColor: AppColors.cream,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.softBeige, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.warmGold, width: 1.5),
                        ),
                        suffixIcon: cart.discountPercent > 0
                            ? const Icon(Icons.check_circle_rounded, color: AppColors.successGreen)
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final applied = cart.applyPromoCode(promoController.text.trim());
                      if (!applied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Invalid promo code'),
                            backgroundColor: Colors.red.shade800,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Promo code applied successfully!'),
                            backgroundColor: AppColors.successGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.espressoBrown,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Apply',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            if (cart.discountPercent > 0)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Promo ${cart.promoCode} applied — 20% discount!',
                    style: GoogleFonts.inter(
                      color: AppColors.successGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // Billing lines
            _SummaryRow('Subtotal', cart.subtotal),
            _SummaryRow('Delivery Fee', CartProvider.deliveryFee),
            _SummaryRow('Tax', cart.taxAmount),
            if (cart.discountAmount > 0)
              _SummaryRow('Promo Discount', -cart.discountAmount, isDiscount: true),
            const Divider(height: 32, color: AppColors.softBeige, thickness: 1.2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal,
                  ),
                ),
                Text(
                  'Rs. ${cart.totalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.warmGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Actions
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.espressoBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.espressoBrown.withValues(alpha: 0.2),
                ),
                child: Text(
                  'Proceed to Checkout',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: onContinue,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.softBeige, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Continue Shopping',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.espressoBrown,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.amount, {this.isDiscount = false});

  final String label;
  final double amount;
  final bool isDiscount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}Rs. ${amount.abs().toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontWeight: isDiscount ? FontWeight.w700 : FontWeight.w600,
              fontSize: 14,
              color: isDiscount ? AppColors.successGreen : AppColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }
}
