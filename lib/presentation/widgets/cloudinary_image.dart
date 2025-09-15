import 'package:flutter/material.dart';
import 'package:innerexec/core/services/cloudinary_service.dart';

/// A widget for displaying Cloudinary images with automatic optimization
class CloudinaryImage extends StatelessWidget {
  /// The public ID of the image in Cloudinary
  final String publicId;

  /// The width of the image
  final double? width;

  /// The height of the image
  final double? height;

  /// How the image should be fitted
  final BoxFit fit;

  /// Placeholder widget while loading
  final Widget? placeholder;

  /// Error widget if image fails to load
  final Widget? errorWidget;

  /// Border radius for the image
  final BorderRadius? borderRadius;

  /// Whether to use thumbnail optimization
  final bool useThumbnail;

  /// Custom quality setting
  final String quality;

  /// Custom format
  final String format;

  const CloudinaryImage({
    super.key,
    required this.publicId,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.useThumbnail = false,
    this.quality = 'auto',
    this.format = 'auto',
  });

  @override
  Widget build(BuildContext context) {
    final cloudinaryService = CloudinaryService();

    String imageUrl;
    if (useThumbnail) {
      imageUrl = cloudinaryService.getThumbnailUrl(
        publicId: publicId,
        size: (width ?? height ?? 150).toInt(),
      );
    } else {
      imageUrl = cloudinaryService.getTransformedImageUrl(
        publicId: publicId,
        width: width?.toInt(),
        height: height?.toInt(),
        quality: quality,
        format: format,
      );
    }

    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.grey),
            );
      },
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}

/// A circular profile image widget using Cloudinary
class CloudinaryProfileImage extends StatelessWidget {
  /// The public ID of the profile image
  final String publicId;

  /// The size of the profile image
  final double size;

  /// Placeholder widget while loading
  final Widget? placeholder;

  /// Error widget if image fails to load
  final Widget? errorWidget;

  const CloudinaryProfileImage({
    super.key,
    required this.publicId,
    this.size = 50,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CloudinaryImage(
      publicId: publicId,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(size / 2),
      useThumbnail: true,
      placeholder:
          placeholder ??
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.grey),
          ),
      errorWidget:
          errorWidget ??
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.grey),
          ),
    );
  }
}
