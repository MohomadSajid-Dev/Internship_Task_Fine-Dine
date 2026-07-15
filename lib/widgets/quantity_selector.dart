import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 36.0 : 42.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.softBeige, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.espressoBrown.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Button(
            size: size,
            icon: Icons.remove,
            onTap: onDecrement,
            isCompact: compact,
          ),
          Container(
            constraints: BoxConstraints(minWidth: compact ? 24 : 32),
            alignment: Alignment.center,
            child: Text(
              '$quantity',
              style: TextStyle(
                fontSize: compact ? 15 : 17,
                fontWeight: FontWeight.w700,
                color: AppColors.charcoal,
              ),
            ),
          ),
          _Button(
            size: size,
            icon: Icons.add,
            onTap: onIncrement,
            filled: true,
            isCompact: compact,
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.size,
    required this.icon,
    required this.onTap,
    this.filled = false,
    required this.isCompact,
  });

  final double size;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.espressoBrown : Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: isCompact ? 16 : 18,
            color: filled ? Colors.white : AppColors.espressoBrown,
          ),
        ),
      ),
    );
  }
}
