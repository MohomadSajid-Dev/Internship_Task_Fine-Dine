import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/food_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/food_image.dart';
import '../widgets/premium_food_card.dart';
import '../widgets/quantity_selector.dart';

class FoodDetailsScreen extends StatefulWidget {
  const FoodDetailsScreen({super.key, required this.foodId});

  final String foodId;

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    final cartQty = context.read<CartProvider>().quantityOf(widget.foodId);
    _quantity = cartQty > 0 ? cartQty : 1;
  }

  @override
  Widget build(BuildContext context) {
    final foodItem = context.read<FoodProvider>().getById(widget.foodId);
    if (foodItem == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: const Center(child: Text('Dish not found')),
      );
    }

    final suggested = context.read<FoodProvider>().getSuggested(widget.foodId);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // 1. Large Hero Food Image with Flexible SliverAppBar
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: AppColors.espressoBrown,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Center(
                child: Material(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.charcoal, size: 18),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
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
                            color: isFav ? const Color(0xFFD32F2F) : AppColors.charcoal,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: FoodImage(
                imageUrl: foodItem.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 2. Main Content Card overlapping the image
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0.0, -28.0, 0.0),
              decoration: const BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dish Name & Restaurant Info
                    Text(
                      foodItem.name,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.charcoal,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Badges List (Rating, Prep Time, Calories)
                    Row(
                      children: [
                        _MetaBadge(
                          icon: Icons.star_rounded,
                          iconColor: AppColors.warmGold,
                          label: foodItem.rating.toString(),
                          description: 'Rating',
                        ),
                        const SizedBox(width: 12),
                        _MetaBadge(
                          icon: Icons.schedule_rounded,
                          iconColor: AppColors.espressoBrown,
                          label: foodItem.prepTime,
                          description: 'Prep Time',
                        ),
                        const SizedBox(width: 12),
                        _MetaBadge(
                          icon: Icons.access_time_filled_rounded,
                          iconColor: const Color(0xFF00796B),
                          label: foodItem.availability,
                          description: 'Availability',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Description
                    const _SectionTitle('Description'),
                    const SizedBox(height: 8),
                    Text(
                      foodItem.description,
                      style: GoogleFonts.inter(
                        height: 1.6,
                        color: AppColors.textSecondary,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Ingredients
                    const _SectionTitle('Ingredients'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: foodItem.ingredients
                          .map((i) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.cardWhite,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.softBeige, width: 1),
                                ),
                                child: Text(
                                  i,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.charcoal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 28),
                    // Spice Level & Quantity rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spice Level',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.charcoal,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              foodItem.spiceLevel,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.espressoBrown,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (index) {
                              final active = foodItem.spiceLevel == 'Hot'
                                  ? true
                                  : foodItem.spiceLevel == 'Medium'
                                      ? index < 2
                                      : index < 1;
                              return Icon(
                                Icons.local_fire_department_rounded,
                                size: 16,
                                color: active ? AppColors.warmGold : Colors.white24,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 40, color: AppColors.softBeige),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal,
                          ),
                        ),
                        QuantitySelector(
                          quantity: _quantity,
                          onDecrement: () {
                            if (_quantity > 1) setState(() => _quantity--);
                          },
                          onIncrement: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // 3. Suggested Dishes Section
                    if (suggested.isNotEmpty) ...[
                      const _SectionTitle('Suggested Dishes'),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 310,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggested.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final item = suggested[index];
                            return SizedBox(
                              width: 280,
                              child: PremiumFoodCard(
                                foodItem: item,
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.foodDetails,
                                  arguments: item.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    // 4. Customer Reviews Section
                    const _SectionTitle('Customer Reviews'),
                    const SizedBox(height: 16),
                    ...foodItem.reviews.map(
                      (review) => Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.espressoBrown.withValues(alpha: 0.03),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.softBeige,
                                  radius: 18,
                                  child: Text(
                                    review.author[0],
                                    style: GoogleFonts.playfairDisplay(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.espressoBrown,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  review.author,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.charcoal,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: i < review.rating ? AppColors.warmGold : AppColors.softBeige,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              review.comment,
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                height: 1.5,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Bottom Action Bar: Price and checkout trigger
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.espressoBrown.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rs. ${(foodItem.price * _quantity).toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.warmGold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<CartProvider>().setItemQuantity(foodItem, _quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${foodItem.name} added to cart'),
                          backgroundColor: AppColors.espressoBrown,
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            textColor: AppColors.warmGold,
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                    label: Text(
                      'Add to Cart',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.espressoBrown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.softBeige, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.espressoBrown.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
