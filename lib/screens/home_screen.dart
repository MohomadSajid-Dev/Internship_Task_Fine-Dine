import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/food_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/chef_selection_card.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/premium_food_card.dart';
import '../widgets/food_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.autoFocusSearch = false});

  final bool autoFocusSearch;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final _scrollController = ScrollController();
  final _bannerPageController = PageController();
  int _activeBannerIndex = 0;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodProvider>().loadFoodItems();
      if (widget.autoFocusSearch) {
        setState(() {
          _isSearching = true;
        });
        _searchFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _scrollController.dispose();
    _bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.warmGold,
          backgroundColor: Colors.white,
          onRefresh: () => context.read<FoodProvider>().refresh(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),

              SliverToBoxAdapter(child: _buildBannerCarousel()),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 28, bottom: 8),
                  child: Center(
                    child: Text(
                      'Today Chef Selections',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildChefSelectionsList()),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _buildCategories(),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Row(
                    children: [
                      Text(
                        'Popular Dishes',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 40,
                        height: 2,
                        color: AppColors.warmGold,
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<FoodProvider>(
                builder: (context, foodProvider, _) {
                  if (foodProvider.isLoading) {
                    return const SliverToBoxAdapter(
                      child: HomeLoadingSkeleton(),
                    );
                  }

                  final popularItems = foodProvider.items;

                  if (popularItems.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded, size: 64, color: AppColors.softBeige),
                            const SizedBox(height: 16),
                            Text(
                              'No dishes found',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverList.separated(
                      itemCount: popularItems.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = popularItems[index];
                        return PremiumFoodCard(
                          foodItem: item,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.foodDetails,
                            arguments: item.id,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isSearching
            ? Row(
                key: const ValueKey('searching_header'),
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        onChanged: (v) => context.read<FoodProvider>().search(v),
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.charcoal),
                        decoration: InputDecoration(
                          hintText: 'Search delicious meals...',
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.warmGold, size: 20),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              context.read<FoodProvider>().search('');
                              setState(() {
                                _isSearching = false;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.softBeige, width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.warmGold, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                key: const ValueKey('normal_header'),
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Hello Sajid',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                              color: AppColors.charcoal,
                            ),
                            children: const [
                              TextSpan(
                                text: '!',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ibbagamuwa, Kurunegala',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            color: const Color(0xFFB08968),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearching = true;
                      });
                      _searchFocus.requestFocus();
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: AppColors.charcoal,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD4E6F1), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFFD4E6F1),
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  static const _promoBanners = [
    'assets/images/promo_banner_1.png',
    'assets/images/promo_banner_2.png',
  ];

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 190,
            child: PageView.builder(
              controller: _bannerPageController,
              itemCount: _promoBanners.length,
              onPageChanged: (index) {
                setState(() {
                  _activeBannerIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildPromoBannerCard(_promoBanners[index]);
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promoBanners.length, (index) {
            final isActive = _activeBannerIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: isActive ? 24 : 8,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFB08968) : const Color(0xFFD5D8DC),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPromoBannerCard(String assetPath) {
    return Container(
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.espressoBrown.withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget _buildChefSelectionsList() {
    return Consumer<FoodProvider>(
      builder: (context, foodProvider, _) {
        if (foodProvider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator(color: AppColors.warmGold)),
          );
        }

        final chefItems = foodProvider.allItems
            .where((item) => item.isChefSelection)
            .toList();

        if (chefItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 350,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: chefItems.length,
            itemBuilder: (context, index) {
              final item = chefItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChefSelectionCard(
                  foodItem: item,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.foodDetails,
                    arguments: item.id,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategories() {
    return Consumer<FoodProvider>(
      builder: (context, foodProvider, _) {
          return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: FoodProvider.categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = FoodProvider.categories[index];
              final isSelected = foodProvider.selectedCategory == category;

              final label = category;

              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => foodProvider.filterByCategory(category),
                showCheckmark: false,
                labelStyle: GoogleFonts.inter(
                  color: isSelected ? Colors.white : AppColors.charcoal,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 13,
                ),
                selectedColor: const Color(0xFFB08968),
                backgroundColor: const Color(0xFFF2E6D8).withValues(alpha: 0.4),
                side: BorderSide(
                  color: isSelected ? const Color(0xFFB08968) : Colors.transparent,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              );
            },
          ),
        );
      },
    );
  }
}
