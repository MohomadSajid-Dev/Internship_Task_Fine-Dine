import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      // Sri Lankan feast spread on a banana leaf
      imageUrl:
          'https://images.unsplash.com/photo-1555126634-323283e090fa?w=800&q=80',
      title: 'Experience fine dining\nlike never before',
    ),
    _OnboardingPage(
      // Elegant plated gourmet dish in restaurant lighting
      imageUrl:
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
      title: 'Discover flavours\nfrom around the world',
    ),
    _OnboardingPage(
      // Warm dessert / sweet treat close-up
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
      title: 'Every meal is a\nspecial moment',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _animController.reset();
    _animController.forward();
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── PageView of full-screen food images ──────────────────────
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),

          // ── Top gradient (for title readability) ─────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xCC000000),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom gradient (for subtitle + button) ───────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 320,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xEE000000),
                    Color(0x88000000),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Content overlay ───────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title at top
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
                    child: Text(
                      _pages[_currentPage].title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.25,
                        shadows: [
                          const Shadow(
                            color: Colors.black54,
                            blurRadius: 12,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ── Page indicator dots ────────────────────────────
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_pages.length, (i) {
                        final isActive = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFC8965A)
                                : Colors.white.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Click to Login button ──────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
                    child: SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _goToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC8965A),
                          foregroundColor: Colors.white,
                          elevation: 10,
                          shadowColor:
                              const Color(0xFFC8965A).withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Click to Login',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Image.network(
      page.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFF1A1A1A),
        child: const Icon(Icons.restaurant, color: Color(0xFFC8965A), size: 80),
      ),
    );
  }
}

class _OnboardingPage {
  final String imageUrl;
  final String title;

  const _OnboardingPage({
    required this.imageUrl,
    required this.title,
  });
}
