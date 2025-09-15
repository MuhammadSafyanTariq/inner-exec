# Cloudinary Usage Examples

## 🚀 Centralized Cloudinary Service

Your project now has a centralized `CloudinaryService` that can be used throughout your entire app for consistent image handling.

## 📱 Basic Usage

### 1. Upload Profile Images
```dart
import 'package:innerexec/core/services/cloudinary_service.dart';

final cloudinaryService = CloudinaryService();

// Upload profile image
String imageUrl = await cloudinaryService.uploadProfileImage(
  imagePath: selectedImage.path,
  userId: currentUser.uid,
);
```

### 2. Upload Post Images
```dart
// Upload post image
String imageUrl = await cloudinaryService.uploadPostImage(
  imagePath: postImage.path,
  postId: postId,
);
```

### 3. Upload Custom Images
```dart
// Upload to custom folder
String imageUrl = await cloudinaryService.uploadCustomImage(
  imagePath: image.path,
  folder: 'gallery',
  fileName: 'vacation_photo_1',
);
```

## 🖼️ Display Images

### 1. Basic Image Display
```dart
import 'package:innerexec/presentation/widgets/cloudinary_image.dart';

CloudinaryImage(
  publicId: 'profile_images/user123',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)
```

### 2. Profile Images (Circular)
```dart
CloudinaryProfileImage(
  publicId: 'profile_images/user123',
  size: 80,
)
```

### 3. Thumbnails
```dart
CloudinaryImage(
  publicId: 'post_images/post456',
  useThumbnail: true,
  width: 150,
  height: 150,
)
```

### 4. Custom Transformations
```dart
CloudinaryImage(
  publicId: 'gallery/photo789',
  width: 300,
  height: 200,
  quality: 'auto:best',
  format: 'webp',
  borderRadius: BorderRadius.circular(12),
)
```

## 🎯 Common Use Cases

### 1. User Profile Screen
```dart
class UserProfileScreen extends StatelessWidget {
  final String userImagePublicId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Large profile image
          CloudinaryProfileImage(
            publicId: userImagePublicId,
            size: 120,
          ),
          
          // Gallery of user photos
          GridView.builder(
            itemCount: userPhotos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              return CloudinaryImage(
                publicId: userPhotos[index],
                useThumbnail: true,
                width: 100,
                height: 100,
              );
            },
          ),
        ],
      ),
    );
  }
}
```

### 2. Post Feed
```dart
class PostCard extends StatelessWidget {
  final String postImagePublicId;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Post image
          CloudinaryImage(
            publicId: postImagePublicId,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          
          // Post content
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Post content...'),
          ),
        ],
      ),
    );
  }
}
```

### 3. Image Upload Screen
```dart
class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final CloudinaryService _cloudinaryService = CloudinaryService();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    
    setState(() => _isUploading = true);
    
    try {
      String imageUrl = await _cloudinaryService.uploadCustomImage(
        imagePath: _selectedImage!.path,
        folder: 'uploads',
        fileName: 'image_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      // Save imageUrl to your database
      print('Image uploaded: $imageUrl');
      
    } catch (e) {
      print('Upload failed: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_selectedImage != null)
            CloudinaryImage(
              publicId: 'temp_preview', // This won't work, just for demo
              width: 200,
              height: 200,
            ),
          
          ElevatedButton(
            onPressed: _isUploading ? null : _uploadImage,
            child: _isUploading 
              ? CircularProgressIndicator() 
              : Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
```

## 🔧 Advanced Features

### 1. Image Transformations
```dart
// Get transformed image URL
final cloudinaryService = CloudinaryService();
String transformedUrl = cloudinaryService.getTransformedImageUrl(
  publicId: 'profile_images/user123',
  width: 300,
  height: 300,
  quality: 'auto:best',
  format: 'webp',
);
```

### 2. Thumbnail Generation
```dart
// Get thumbnail URL
String thumbnailUrl = cloudinaryService.getThumbnailUrl(
  publicId: 'post_images/post456',
  size: 150,
);
```

## 📁 Folder Structure

Your Cloudinary account will be organized like this:
```
dav4kluhd/
├── profile_images/
│   ├── user123.jpg
│   ├── user456.jpg
│   └── ...
├── post_images/
│   ├── post789.jpg
│   ├── post101.jpg
│   └── ...
├── gallery/
│   ├── vacation_photo_1.jpg
│   └── ...
└── uploads/
    ├── image_1234567890.jpg
    └── ...
```

## 🎨 Benefits

- ✅ **Automatic Optimization**: Images are automatically optimized
- ✅ **Multiple Formats**: WebP, AVIF support for better performance
- ✅ **Global CDN**: Fast delivery worldwide
- ✅ **Transformations**: On-the-fly resizing, cropping, filters
- ✅ **Consistent API**: Same service used throughout your app
- ✅ **Error Handling**: Built-in error handling and placeholders
- ✅ **Thumbnails**: Automatic thumbnail generation
- ✅ **Free Tier**: 25GB storage + 25GB bandwidth monthly

## 🚀 Ready to Use!

Your Cloudinary integration is now ready for use throughout your entire Flutter project! 🎯
