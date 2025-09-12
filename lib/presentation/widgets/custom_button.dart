import 'package:flutter/material.dart';

/// Custom button widget with consistent styling across the app
class CustomButton extends StatelessWidget {
  /// The text to display on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Whether the button is enabled
  final bool isEnabled;

  /// Custom width for the button (default: 340)
  final double? width;

  /// Custom height for the button (default: 54)
  final double? height;

  /// Custom background color (default: #8B51FE)
  final Color? backgroundColor;

  /// Custom text color (default: #FFFFFF)
  final Color? textColor;

  /// Custom border radius (default: 8)
  final double? borderRadius;

  /// Icon to display before the text
  final IconData? icon;

  /// Creates a new custom button
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? 340.0;
    final effectiveHeight = height ?? 54.0;
    final effectiveBackgroundColor = backgroundColor ?? const Color(0xFF8B51FE);
    final effectiveTextColor = textColor ?? const Color(0xFFFFFFFF);
    final effectiveBorderRadius = borderRadius ?? 8.0;

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          disabledBackgroundColor: effectiveBackgroundColor.withOpacity(0.6),
          disabledForegroundColor: effectiveTextColor.withOpacity(0.6),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: effectiveTextColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.0, // 100% line height
                      letterSpacing: 0.0,
                      color: effectiveTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}

/// Custom outlined button widget with consistent styling
class CustomOutlinedButton extends StatelessWidget {
  /// The text to display on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Whether the button is enabled
  final bool isEnabled;

  /// Custom width for the button (default: 340)
  final double? width;

  /// Custom height for the button (default: 54)
  final double? height;

  /// Custom border color (default: #8B51FE)
  final Color? borderColor;

  /// Custom text color (default: #8B51FE)
  final Color? textColor;

  /// Custom border radius (default: 8)
  final double? borderRadius;

  /// Icon to display before the text
  final IconData? icon;

  /// Creates a new custom outlined button
  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? 340.0;
    final effectiveHeight = height ?? 54.0;
    final effectiveBorderColor = borderColor ?? const Color(0xFF8B51FE);
    final effectiveTextColor = textColor ?? const Color(0xFF8B51FE);
    final effectiveBorderRadius = borderRadius ?? 8.0;

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: OutlinedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveTextColor,
          disabledForegroundColor: effectiveTextColor.withOpacity(0.6),
          side: BorderSide(color: effectiveBorderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: effectiveTextColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.0, // 100% line height
                      letterSpacing: 0.0,
                      color: effectiveTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
