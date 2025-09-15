# Cloudinary Setup Instructions

## 1. Create Cloudinary Account
1. Go to [Cloudinary.com](https://cloudinary.com)
2. Sign up for a free account
3. Verify your email address

## 2. Get Your Credentials
1. Log in to your Cloudinary dashboard
2. Go to the "Dashboard" section
3. Copy your **Cloud Name** (you'll need this)

## 3. Configure Upload Preset (Recommended)
1. In your Cloudinary dashboard, go to **Settings** → **Upload**
2. Scroll down to **Upload presets**
3. Click **Add upload preset**
4. Set the following:
   - **Preset name**: `profile_images` (or any name you prefer)
   - **Signing Mode**: `Unsigned` (for client-side uploads)
   - **Folder**: `profile_images` (optional)
5. Click **Save**

## 4. Update Configuration
1. Open `lib/core/constants/cloudinary_config.dart`
2. Replace the placeholder values:

```dart
class CloudinaryConfig {
  static const String cloudName = 'your_actual_cloud_name'; // From dashboard
  static const String uploadPreset = 'profile_images'; // Your preset name
}
```

## 5. Test the Integration
1. Run your Flutter app
2. Go to Profile Setup screen
3. Try uploading an image
4. Check your Cloudinary dashboard to see the uploaded image

## Benefits of Cloudinary
- ✅ **Automatic Image Optimization**: Resizes, compresses, and optimizes images
- ✅ **Multiple Formats**: Delivers images in WebP, AVIF, etc.
- ✅ **CDN**: Fast global delivery
- ✅ **Transformations**: On-the-fly image transformations
- ✅ **Free Tier**: 25GB storage, 25GB bandwidth per month

## Security Notes
- Using unsigned uploads with upload presets is secure for client-side uploads
- The upload preset controls what can be uploaded
- Images are automatically optimized and delivered via CDN
