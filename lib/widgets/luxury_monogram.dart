import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated luxury monogram logo for FINE DINE.
/// Plays a looping multi-stage animation:
///   1. Fade + scale entry
///   2. Fork & spoon stroke draw-in
///   3. Rotating outer gold ring
///   4. Pulsing glow halo
///   5. Subtle shimmer on the inner plate
class LuxuryMonogram extends StatefulWidget {
  const LuxuryMonogram({
    super.key,
    this.size = 140.0,
    // kept for backwards-compat but ignored – animation is self-contained
    this.animationValue = 1.0,
  });

  final double size;
  final double animationValue;

  @override
  State<LuxuryMonogram> createState() => _LuxuryMonogramState();
}

class _LuxuryMonogramState extends State<LuxuryMonogram>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final AnimationController _rotateCtrl;
  late final AnimationController _pulseCtrl;

  late final Animation<double> _drawAnim;   // fork/spoon stroke draw-in
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    // 1. Entry animation (runs once, 1.4 s)
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _drawAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );

    _entryCtrl.forward();

    // 2. Continuous ring rotation (loops forever)
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // 3. Pulse glow (loops forever, 2 s period)
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.18, end: 0.45).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _rotateCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entryCtrl, _rotateCtrl, _pulseCtrl]),
      builder: (context, _) {
        return FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: _MonogramPainter(
                  drawProgress: _drawAnim.value,
                  rotateAngle: _rotateCtrl.value * 2 * pi,
                  glowAlpha: _pulseAnim.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Painter
// ─────────────────────────────────────────────
class _MonogramPainter extends CustomPainter {
  _MonogramPainter({
    required this.drawProgress,
    required this.rotateAngle,
    required this.glowAlpha,
  });

  final double drawProgress; // 0 → 1, controls fork/spoon stroke draw-in
  final double rotateAngle;  // radians, for spinning dashed ring
  final double glowAlpha;    // 0 → 1, pulsing glow strength

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    // ── Pulsing outer glow halo ──────────────────────────
    final glowPaint = Paint()
      ..color = AppColors.warmGold.withValues(alpha: glowAlpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawCircle(center, r - 2, glowPaint);

    // ── Rotating segmented outer ring ────────────────────
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotateAngle);
    canvas.translate(-center.dx, -center.dy);

    final segPaint = Paint()
      ..color = AppColors.warmGold.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    const segCount = 24;
    const segAngle = (2 * pi) / segCount;
    const gap = 0.03; // radians gap between segments
    for (var i = 0; i < segCount; i++) {
      final start = i * segAngle + gap;
      final sweep = segAngle - gap * 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r - 4),
        start,
        sweep,
        false,
        segPaint,
      );
    }
    canvas.restore();

    // ── Inner solid ring ─────────────────────────────────
    final innerRimPaint = Paint()
      ..color = AppColors.warmGold.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, r - 14, innerRimPaint);

    // ── Plate base fill ───────────────────────────────────
    final platePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.cardWhite.withValues(alpha: 0.18),
          AppColors.espressoBrown.withValues(alpha: 0.40),
        ],
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r - 15));
    canvas.drawCircle(center, r - 15, platePaint);

    // ── Corner diamond dots ───────────────────────────────
    if (drawProgress > 0.5) {
      final dotAlpha = ((drawProgress - 0.5) * 2).clamp(0.0, 1.0);
      final dotPaint = Paint()
        ..color = AppColors.warmGold.withValues(alpha: dotAlpha * 0.6)
        ..style = PaintingStyle.fill;
      const dotAngles = [pi / 4, 3 * pi / 4, 5 * pi / 4, 7 * pi / 4];
      for (final angle in dotAngles) {
        final dx = center.dx + cos(angle) * (r - 20);
        final dy = center.dy + sin(angle) * (r - 20);
        canvas.drawCircle(Offset(dx, dy), 2.0, dotPaint);
      }
    }

    // ── Fork & Spoon stroke draw-in ───────────────────────
    final s = (r - 22) / 28.0; // scale factor

    final cutleryPaint = Paint()
      ..color = AppColors.warmGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    _drawFork(canvas, center, s, drawProgress, cutleryPaint);
    _drawSpoon(canvas, center, s, drawProgress, cutleryPaint);
  }

  /// Draws a fork to the left of center, with animated draw-in.
  void _drawFork(
    Canvas canvas,
    Offset center,
    double s,
    double progress,
    Paint paint,
  ) {
    if (progress <= 0) return;

    final cx = center.dx - 10 * s;

    // Handle bottom → top
    final handleTop = center.dy - 4 * s;
    final handleBottom = center.dy + 18 * s;
    final handleLen = handleBottom - handleTop;
    final drawnHandle = (progress * 2).clamp(0.0, 1.0);
    canvas.drawLine(
      Offset(cx, handleBottom),
      Offset(cx, handleBottom - handleLen * drawnHandle),
      paint,
    );

    // Arch base
    if (progress > 0.4) {
      final archProgress = ((progress - 0.4) / 0.3).clamp(0.0, 1.0);
      final archPaint = Paint()
        ..color = AppColors.warmGold.withValues(alpha: archProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromLTRB(cx - 5 * s, center.dy - 14 * s, cx + 5 * s, center.dy - 4 * s),
        0,
        pi,
        false,
        archPaint,
      );
    }

    // Tines (3 lines)
    if (progress > 0.55) {
      final tineProgress = ((progress - 0.55) / 0.45).clamp(0.0, 1.0);
      final tineAlpha = tineProgress;
      final tinePaint = Paint()
        ..color = AppColors.warmGold.withValues(alpha: tineAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;
      final tineTop = center.dy - 14 * s;
      final tineBase = center.dy - 10 * s;
      final tineLen = (tineBase - tineTop) * tineProgress;

      for (final xOff in [-5.0, 0.0, 5.0]) {
        canvas.drawLine(
          Offset(cx + xOff * s, tineBase),
          Offset(cx + xOff * s, tineBase - tineLen * 2),
          tinePaint,
        );
      }
    }
  }

  /// Draws a spoon to the right of center, with animated draw-in.
  void _drawSpoon(
    Canvas canvas,
    Offset center,
    double s,
    double progress,
    Paint paint,
  ) {
    if (progress <= 0) return;

    final cx = center.dx + 10 * s;

    // Handle
    final handleTop = center.dy - 5 * s;
    final handleBottom = center.dy + 18 * s;
    final handleLen = handleBottom - handleTop;
    final drawnHandle = (progress * 2).clamp(0.0, 1.0);
    canvas.drawLine(
      Offset(cx, handleBottom),
      Offset(cx, handleBottom - handleLen * drawnHandle),
      paint,
    );

    // Bowl (filled oval, appears after handle)
    if (progress > 0.5) {
      final bowlProgress = ((progress - 0.5) / 0.5).clamp(0.0, 1.0);
      final bowlPaint = Paint()
        ..color = AppColors.warmGold.withValues(alpha: bowlProgress)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, center.dy - 11 * s),
          width: 8 * s * bowlProgress,
          height: 12 * s * bowlProgress,
        ),
        bowlPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MonogramPainter old) =>
      old.drawProgress != drawProgress ||
      old.rotateAngle != rotateAngle ||
      old.glowAlpha != glowAlpha;
}
