import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _scaleController.forward();
    _confettiController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final total = (args?['total'] as num?)?.toDouble() ?? 0.0;
    final orderId =
        '#FD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // Falling Confetti Animation Layer
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, _) => CustomPaint(
              painter: _ConfettiPainter(
                progress: _confettiController.value,
                random: _random,
              ),
              size: Size.infinite,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  // Animated Success Badge
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Center(
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cardWhite,
                          border: Border.all(color: AppColors.warmGold, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.successGreen.withValues(alpha: 0.15),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 106,
                            height: 106,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.successGreen.withValues(alpha: 0.1),
                            ),
                            child: const Icon(
                              Icons.check_circle_rounded,
                              size: 72,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Order Confirmed',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your delicious meal is being prepared.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Estimated Delivery Time Progress Indicator
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.softBeige, width: 1.2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.directions_bike_rounded, color: AppColors.warmGold, size: 24),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Estimated Delivery',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '25–30 Minutes',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.charcoal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Mini Delivery Timeline Graphic
                        Row(
                          children: [
                            _TimelineNode(active: true, title: 'Confirmed'),
                            _TimelineLine(active: true),
                            _TimelineNode(active: true, title: 'Preparing', isCurrent: true),
                            _TimelineLine(active: false),
                            _TimelineNode(active: false, title: 'Delivering'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Premium Receipt Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.espressoBrown.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: AppColors.softBeige, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECEIPT DETAILS',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.warmGold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _DetailRow('Order ID', orderId),
                        const Divider(height: 24, color: AppColors.softBeige),
                        _DetailRow('Total Paid', 'Rs. ${total.toStringAsFixed(2)}'),
                        const Divider(height: 24, color: AppColors.softBeige),
                        _DetailRow('Payment Mode', 'Debit Card '),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.espressoBrown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Track Order',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.main,
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.softBeige, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Back to Home',
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
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppColors.charcoal,
          ),
        ),
      ],
    );
  }
}

class _TimelineNode extends StatelessWidget {
  const _TimelineNode({required this.active, required this.title, this.isCurrent = false});

  final bool active;
  final String title;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? AppColors.warmGold : Colors.transparent,
              border: Border.all(
                color: active ? AppColors.warmGold : AppColors.softBeige,
                width: 2.0,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: AppColors.warmGold.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
            child: isCurrent
                ? const Center(
                    child: Icon(Icons.circle, size: 8, color: Colors.white),
                  )
                : active
                    ? const Center(
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      )
                    : null,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? AppColors.charcoal : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineLine extends StatelessWidget {
  const _TimelineLine({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: active ? AppColors.warmGold : AppColors.softBeige,
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress, required this.random});

  final double progress;
  final Random random;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1.0) return;

    final colors = [
      AppColors.warmGold,
      AppColors.espressoBrown,
      AppColors.successGreen,
      AppColors.softBeige,
    ];

    // Seed the random with a deterministic key based on painting frames if desired,
    // but a standard random with simple coordinate mapping is fine since it animates continuously.
    for (var i = 0; i < 60; i++) {
      final seedX = (sin(i.toDouble() * 32.5) + 1.0) / 2.0; // range 0..1
      final seedSpeed = (cos(i.toDouble() * 15.3) + 1.2) / 2.0; // range 0.1..1.1

      final x = seedX * size.width + sin(progress * pi * 2 + i) * 15;
      final startY = -20.0;
      final endY = size.height + 20.0;
      final y = startY + (endY - startY) * progress * seedSpeed;

      if (y > size.height || y < 0) continue;

      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: 1 - progress * 0.8)
        ..style = PaintingStyle.fill;

      // Draw squares, circles, and small stars / triangles
      final particleSize = 4.0 + (i % 6);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * pi * (i % 4));

      if (i % 3 == 0) {
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: particleSize, height: particleSize * 1.5), paint);
      } else if (i % 3 == 1) {
        canvas.drawCircle(Offset.zero, particleSize / 2, paint);
      } else {
        // Triangle
        final path = Path();
        path.moveTo(0, -particleSize / 2);
        path.lineTo(particleSize / 2, particleSize / 2);
        path.lineTo(-particleSize / 2, particleSize / 2);
        path.close();
        canvas.drawPath(path, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
