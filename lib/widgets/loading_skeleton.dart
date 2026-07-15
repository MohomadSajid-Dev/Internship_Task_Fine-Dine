import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({
    super.key,
    this.height = 16,
    this.width,
    this.borderRadius = 12,
  });

  final double height;
  final double? width;
  final double borderRadius;

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.softBeige.withValues(alpha: 0.5 + _controller.value * 0.3),
                AppColors.softBeige,
                AppColors.softBeige.withValues(alpha: 0.5 + _controller.value * 0.3),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingSkeleton(height: 48, borderRadius: 16),
          const SizedBox(height: 16),
          const LoadingSkeleton(height: 52, borderRadius: 18),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, _) => const LoadingSkeleton(
                height: 40,
                width: 80,
                borderRadius: 18,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const LoadingSkeleton(height: 180, borderRadius: 24),
          const SizedBox(height: 24),
          ...List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: LoadingSkeleton(height: 140, borderRadius: 24),
            ),
          ),
        ],
      ),
    );
  }
}
