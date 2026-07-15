import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import 'food_image.dart';

class PremiumFoodCard extends StatelessWidget {
  const PremiumFoodCard({
    super.key,
    required this.foodItem,
    required this.onTap,
  });

  final FoodItem foodItem;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.espressoBrown.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                FoodImage(
                  imageUrl: foodItem.imageUrl,
                  height: 200,
                  width: double.infinity,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                // Premium Overlay Gradients
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 14,
                  right: 14,
                  child: Consumer<FavoritesProvider>(
                    builder: (context, favorites, _) {
                      final isFav = favorites.isFavorite(foodItem.id);
                      return Material(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => favorites.toggleFavorite(foodItem.id),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border_rounded,
                              color: isFav ? const Color(0xFFD32F2F) : AppColors.espressoBrown,
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Vegetarian/Spice Badge
                if (foodItem.isVegetarian)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lens, color: Colors.white, size: 8),
                          const SizedBox(width: 4),
                          Text(
                            'VEGETARIAN',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foodItem.name,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.charcoal,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rs. ${foodItem.price.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.espressoBrown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    foodItem.shortDescription,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.softBeige, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.warmGold, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              foodItem.rating.toString(),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Prep Time
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.softBeige, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.schedule_rounded, color: AppColors.espressoBrown, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              foodItem.prepTime,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Add Button
                      Material(
                        color: AppColors.espressoBrown,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            context.read<CartProvider>().addItem(foodItem);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${foodItem.name} added to cart'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppColors.espressoBrown,
                                action: SnackBarAction(
                                  label: 'VIEW CART',
                                  textColor: AppColors.warmGold,
                                  onPressed: () {
                                    // Normally we would route to cart, let's keep it simple
                                  },
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.add_shopping_cart_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
