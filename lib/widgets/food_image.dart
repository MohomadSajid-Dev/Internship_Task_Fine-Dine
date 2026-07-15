import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FoodImage extends StatelessWidget {
  const FoodImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final Widget image = imageUrl.startsWith('assets/')
        ? Image.asset(
            imageUrl,
            height: height,
            width: width,
            fit: fit,
            errorBuilder: (_, _, _) => _errorPlaceholder(),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            height: height,
            width: width,
            fit: fit,
            placeholder: (_, _) => _loadingPlaceholder(),
            errorWidget: (_, _, _) => _errorPlaceholder(),
          );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _loadingPlaceholder() => Container(
        height: height,
        width: width,
        color: AppColors.softBeige,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.warmGold,
          ),
        ),
      );

  Widget _errorPlaceholder() => Container(
        height: height,
        width: width,
        color: AppColors.softBeige,
        child: const Icon(Icons.restaurant, color: AppColors.warmGold, size: 40),
      );
}
