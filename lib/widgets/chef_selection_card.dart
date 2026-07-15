import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'food_image.dart';

class ChefSelectionCard extends StatelessWidget {
  const ChefSelectionCard({
    super.key,
    required this.foodItem,
    required this.onTap,
  });

  final FoodItem foodItem;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const cardWidth = 220.0;
    const cardHeight = 280.0;
    const imageSize = 150.0;
    const buttonSize = 54.0;

    final priceString = 'Rs. ${foodItem.price.toStringAsFixed(2)}';
    const subtitle = 'Premium Selection';

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth + 16, // Extra padding for horizontal margins
        height: cardHeight + 60, // Sized to accommodate top/bottom overflows
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // 1. The Main rounded card background (starts 40px down)
            Positioned(
              top: 50,
              child: Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFB08968), // Rich cocoa brown color from image
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.espressoBrown.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFE6CCB2).withValues(alpha: 0.7), // Gold/cream textured border
                    width: 3.5,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 110, 16, 20),
                child: Column(
                  children: [
                    // Price Row
                    Text(
                      priceString,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFF9F3),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Item Name
                    Text(
                      foodItem.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Subtitle (e.g. Volume Large)
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFFFFF9F3).withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    // Rating Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final ratingInt = foodItem.rating.floor();
                        final isHalf = (foodItem.rating - ratingInt) >= 0.4;
                        final active = index < ratingInt;
                        final half = index == ratingInt && isHalf;

                        return Icon(
                          half
                              ? Icons.star_half_rounded
                              : active
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                          color: const Color(0xFFFFB703),
                          size: 18,
                        );
                      }),
                    ),
                    const SizedBox(height: 32), // Leave space for overflowing button
                  ],
                ),
              ),
            ),
            // 2. Overlapping Circular Food Plate/Cup Image at the Top
            Positioned(
              top: 0,
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // If it's the Cappuccino, we can display a custom latte art image
                      FoodImage(
                        imageUrl: foodItem.name.toLowerCase().contains('cappuccino')
                            ? 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&q=80' // Beautiful cup from top view
                            : foodItem.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 3. Overlapping Plus Button at the Bottom
            Positioned(
              bottom: 12,
              child: Material(
                color: const Color(0xFFF39C12), // Bright orange-gold button color from image
                shape: const CircleBorder(),
                elevation: 6,
                shadowColor: Colors.black45,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    context.read<CartProvider>().addItem(foodItem);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${foodItem.name} added to cart'),
                        backgroundColor: AppColors.espressoBrown,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  child: const SizedBox(
                    width: buttonSize,
                    height: buttonSize,
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
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
