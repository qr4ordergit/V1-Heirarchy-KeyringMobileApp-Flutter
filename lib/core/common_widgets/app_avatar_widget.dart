import 'package:flutter/material.dart';
import 'default_profile_avatar.dart';
import 'image_widget.dart';
/// Circular avatar that shows an image (network or local asset) when
/// [imageUrl] is present, and falls back to initials (via
/// [DefaultProfileAvatar]) when there's no image, or when a network image
/// fails to load.
///
/// This is the single place that decides "image vs initials" and
/// "network vs asset" so call sites never branch on that themselves.
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final bool isNetworkImage;
  final String? fallbackText;
  final double? width;
  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final Color? textColor;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.isNetworkImage = true,
    this.fallbackText,
    this.radius,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
  });

  bool get _hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final Widget initialsAvatar = DefaultProfileAvatar(
      text: fallbackText,
      radius: radius,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );

    if (!_hasImage) return initialsAvatar;

    return ClipOval(
      child: ImageWidget(
        imageUrl: imageUrl!,
        isNetworkImage: isNetworkImage,
        width: width,
        height: height,
        fit: BoxFit.cover,
        // Asset images can't fail at runtime the way network calls can
        // (a missing asset is a build-time/dev error, not a fallback
        // case), so the error fallback only matters for network images.
        errorFallback: isNetworkImage ? initialsAvatar : null,
      ),
    );
  }
}