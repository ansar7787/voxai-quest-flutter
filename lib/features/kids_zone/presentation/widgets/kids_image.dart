import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KidsImage extends StatelessWidget {
  final String? imageUrl;
  final IconData fallbackIcon;
  final double? size;
  final Color? iconColor;

  const KidsImage({
    super.key,
    this.imageUrl,
    required this.fallbackIcon,
    this.size,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallback();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Check if it's a network URL
    if (imageUrl!.startsWith('http') || imageUrl!.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.contain,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: isDark ? Colors.white : Colors.blueAccent,
          ),
        ),
        errorWidget: (context, url, error) => _buildFallback(),
      );
    }

    // Check if it's a local asset
    if (imageUrl!.startsWith('assets/')) {
      return Image.asset(
        imageUrl!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    // If it's a prompt (e.g., "3d clay lion"), show the fallback icon
    // but maybe with a subtle hint or placeholder
    return _buildFallback();
  }

  Widget _buildFallback() {
    return Center(
      child: Icon(
        fallbackIcon,
        size: size ?? 80.sp,
        color: iconColor ?? Colors.grey[300],
      ),
    );
  }
}
