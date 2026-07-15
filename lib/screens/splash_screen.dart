import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/luxury_monogram.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    _controller.forward();
  }

  void _goToOnboarding() {
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E110A), // Extra dark espresso
              Color(0xFF2E190E),
              AppColors.espressoBrown,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Glowing radial background overlays
            Positioned(
              top: -120,
              right: -80,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warmGold.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -120,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warmGold.withValues(alpha: 0.06),
                ),
              ),
            ),
            // Subtle dotted/grid food pattern
            Positioned.fill(
              child: Opacity(
                opacity: 0.04,
                child: CustomPaint(painter: _PatternPainter()),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            children: [
                              LuxuryMonogram(size: 140),
                              const SizedBox(height: 40),
                              Text(
                                'FINE DINE',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 8,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Elegant tagline with gold borders
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                    horizontal: BorderSide(
                                      color: AppColors.warmGold.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Every Meal is an Experience',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.warmGold,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(flex: 3),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _goToOnboarding,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.warmGold,
                            foregroundColor: AppColors.espressoBrown,
                            elevation: 8,
                            shadowColor: AppColors.espressoBrown.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
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

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.warmGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (var i = 20.0; i < size.width; i += 40.0) {
      for (var j = 20.0; j < size.height; j += 40.0) {
        // Draw elegant small cross stars
        canvas.drawLine(Offset(i - 2, j), Offset(i + 2, j), paint);
        canvas.drawLine(Offset(i, j - 2), Offset(i, j + 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
