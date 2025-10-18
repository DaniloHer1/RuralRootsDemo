// lib/shared/widget/cached_images.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

/// Widget optimizado para cargar imágenes desde internet con caché
class OptimizedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay URL, mostrar placeholder
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      // Placeholder mientras carga
      placeholder: (context, url) {
        return placeholder ??
            Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
                strokeWidth: 2,
              ),
            );
      },
      // Widget de error si falla la carga
      errorWidget: (context, url, error) {
        return errorWidget ?? _buildErrorWidget();
      },
      // Optimizaciones de memoria
      memCacheWidth: width != null ? (width! * 2).toInt() : 600,
      memCacheHeight: height != null ? (height! * 2).toInt() : 600,
      maxWidthDiskCache: 1000,
      maxHeightDiskCache: 1000,
    );

    // Aplicar border radius si se especifica
    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Widget de placeholder por defecto
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightGreen.withOpacity(0.2),
        borderRadius: borderRadius,
      ),
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.primaryGreen,
        size: 48,
      ),
    );
  }

  /// Widget de error por defecto
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: borderRadius,
      ),
      child: const Icon(
        Icons.broken_image_outlined,
        color: Colors.grey,
        size: 48,
      ),
    );
  }
}

/// Widget circular optimizado para avatares
class CircularCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;

  const CircularCachedImage({
    super.key,
    this.imageUrl,
    this.size = 50,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.lightGreen.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                    strokeWidth: 2,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  color: AppColors.primaryGreen,
                ),
                memCacheWidth: (size * 2).toInt(),
                memCacheHeight: (size * 2).toInt(),
              )
            : const Icon(
                Icons.person,
                color: AppColors.primaryGreen,
              ),
      ),
    );
  }
}

/// Widget para imágenes de productos con esquinas redondeadas
class ProductImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;

  const ProductImage({
    super.key,
    this.imageUrl,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return OptimizedImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(12),
      fit: BoxFit.cover,
      placeholder: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.lightGreen.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.eco,
          color: AppColors.primaryGreen,
          size: 40,
        ),
      ),
      errorWidget: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.lightGreen.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.eco,
          color: AppColors.primaryGreen,
          size: 40,
        ),
      ),
    );
  }
}