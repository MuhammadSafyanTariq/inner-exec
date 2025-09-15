import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:innerexec/core/constants/cloudinary_config.dart';

/// Centralized Cloudinary service for image uploads across the entire app
class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    CloudinaryConfig.cloudName,
    CloudinaryConfig.uploadPreset,
  );

  /// Uploads an image file to Cloudinary
  ///
  /// [imageFile] - The image file to upload
  /// [folder] - The folder to store the image in (e.g., 'profile_images', 'post_images')
  /// [publicId] - Optional custom public ID for the image
  ///
  /// Returns the secure URL of the uploaded image
  Future<String> uploadImage({
    required String imagePath,
    required String folder,
    String? publicId,
  }) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imagePath,
          publicId:
              publicId ?? '${folder}_${DateTime.now().millisecondsSinceEpoch}',
          folder: folder,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Uploads a profile image
  ///
  /// [imagePath] - Path to the image file
  /// [userId] - User ID to use as public ID
  ///
  /// Returns the secure URL of the uploaded profile image
  Future<String> uploadProfileImage({
    required String imagePath,
    required String userId,
  }) async {
    return uploadImage(
      imagePath: imagePath,
      folder: 'profile_images',
      publicId: 'profile_images/$userId',
    );
  }

  /// Uploads a post image
  ///
  /// [imagePath] - Path to the image file
  /// [postId] - Post ID to use as public ID
  ///
  /// Returns the secure URL of the uploaded post image
  Future<String> uploadPostImage({
    required String imagePath,
    required String postId,
  }) async {
    return uploadImage(
      imagePath: imagePath,
      folder: 'post_images',
      publicId: 'post_images/$postId',
    );
  }

  /// Uploads a general image with custom folder
  ///
  /// [imagePath] - Path to the image file
  /// [folder] - Custom folder name
  /// [fileName] - Custom file name
  ///
  /// Returns the secure URL of the uploaded image
  Future<String> uploadCustomImage({
    required String imagePath,
    required String folder,
    required String fileName,
  }) async {
    return uploadImage(
      imagePath: imagePath,
      folder: folder,
      publicId: '$folder/$fileName',
    );
  }

  /// Generates a Cloudinary URL with transformations
  ///
  /// [publicId] - The public ID of the image
  /// [width] - Desired width
  /// [height] - Desired height
  /// [quality] - Image quality (auto, auto:good, auto:best, etc.)
  /// [format] - Image format (webp, jpg, png, etc.)
  ///
  /// Returns the transformed image URL
  String getTransformedImageUrl({
    required String publicId,
    int? width,
    int? height,
    String quality = 'auto',
    String format = 'auto',
  }) {
    final baseUrl =
        'https://res.cloudinary.com/${CloudinaryConfig.cloudName}/image/upload';

    String transformations = '';
    if (width != null || height != null) {
      transformations += 'w_${width ?? 'auto'},h_${height ?? 'auto'},c_fill/';
    }
    transformations += 'q_$quality,f_$format/';

    return '$baseUrl/$transformations$publicId';
  }

  /// Generates a thumbnail URL for an image
  ///
  /// [publicId] - The public ID of the image
  /// [size] - Thumbnail size (default: 150x150)
  ///
  /// Returns the thumbnail URL
  String getThumbnailUrl({required String publicId, int size = 150}) {
    return getTransformedImageUrl(
      publicId: publicId,
      width: size,
      height: size,
      quality: 'auto',
      format: 'webp',
    );
  }
}
