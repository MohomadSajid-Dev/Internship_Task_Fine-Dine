import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

enum ProfileTab { orders, profile }

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.tab});

  final ProfileTab tab;

  @override
  Widget build(BuildContext context) {
    final isOrders = tab == ProfileTab.orders;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isOrders ? 'My Orders' : 'Profile',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isOrders
                    ? 'Your order history and live updates'
                    : 'Manage your FINE DINE membership and settings',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 2),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.espressoBrown.withValues(alpha: 0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: AppColors.softBeige, width: 1.2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.softBeige, width: 1),
                        ),
                        child: Icon(
                          isOrders
                              ? Icons.receipt_long_outlined
                              : Icons.person_outline_rounded,
                          size: 42,
                          color: AppColors.warmGold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isOrders ? 'No Orders Yet' : 'Sajid',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isOrders
                            ? 'Place your first order to see it here'
                            : 'This feature available soon',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      if (!isOrders) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.warmGold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
