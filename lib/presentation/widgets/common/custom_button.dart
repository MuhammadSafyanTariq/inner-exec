import 'package:flutter/material.dart';

/// A customizable button widget with consistent styling
class CustomButton extends StatelessWidget {
  /// Creates a new custom button
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.height = 48.0,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disabledColor,
    this.icon,
    this.iconPosition = IconPosition.start,
  });

  /// The text to display on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Whether the button has an outlined style
  final bool isOutlined;

  /// Whether the button should take full width
  final bool isFullWidth;

  /// Height of the button
  final double height;

  /// Custom text style for the button text
  final TextStyle? textStyle;

  /// Background color of the button
  final Color? backgroundColor;

  /// Foreground color of the button (text and icon)
  final Color? foregroundColor;

  /// Border color for outlined buttons
  final Color? borderColor;

  /// Color when button is disabled
  final Color? disabledColor;

  /// Icon to display on the button
  final IconData? icon;

  /// Position of the icon relative to text
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    // Determine colors
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimary;
    final borderCol = borderColor ?? theme.colorScheme.primary;
    final disabledCol =
        disabledColor ?? theme.colorScheme.onSurface.withOpacity(0.12);

    // Determine button style
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: isEnabled
                ? borderCol
                : theme.colorScheme.onSurface.withOpacity(0.38),
            side: BorderSide(
              color: isEnabled
                  ? borderCol
                  : theme.colorScheme.onSurface.withOpacity(0.12),
              width: 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? bgColor : disabledCol,
            foregroundColor: isEnabled
                ? fgColor
                : theme.colorScheme.onSurface.withOpacity(0.38),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
          );

    // Create button content
    Widget buttonContent;
    if (isLoading) {
      buttonContent = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? borderCol : fgColor,
          ),
        ),
      );
    } else {
      final textWidget = Text(
        text,
        style:
            textStyle ??
            theme.textTheme.labelLarge?.copyWith(
              color: isEnabled
                  ? (isOutlined ? borderCol : fgColor)
                  : theme.colorScheme.onSurface.withOpacity(0.38),
            ),
      );

      if (icon != null) {
        final iconWidget = Icon(
          icon,
          size: 20,
          color: isEnabled
              ? (isOutlined ? borderCol : fgColor)
              : theme.colorScheme.onSurface.withOpacity(0.38),
        );

        buttonContent = iconPosition == IconPosition.start
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [iconWidget, const SizedBox(width: 8), textWidget],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [textWidget, const SizedBox(width: 8), iconWidget],
              );
      } else {
        buttonContent = textWidget;
      }
    }

    // Return appropriate button type
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: buttonContent,
      );
    } else {
      return ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: buttonContent,
      );
    }
  }
}

/// Enum for icon positioning in buttons
enum IconPosition {
  /// Icon appears before the text
  start,

  /// Icon appears after the text
  end,
}
