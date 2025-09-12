import 'package:flutter/material.dart';

/// Custom primary text widget with consistent typography
class CustomPrimaryText extends StatelessWidget {
  /// The text to display
  final String text;

  /// Custom text color (default: based on theme)
  final Color? color;

  /// Text alignment (default: start)
  final TextAlign? textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow? overflow;

  /// Whether the text should be selectable
  final bool selectable;

  /// Creates a new custom primary text
  const CustomPrimaryText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.onSurface;

    final textWidget = Text(
      text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500, // Medium
        fontSize: 36,
        height: 1.0, // 100% line height
        letterSpacing: 0.0,
        color: effectiveColor,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

    if (selectable) {
      return SelectableText(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500, // Medium
          fontSize: 36,
          height: 1.0, // 100% line height
          letterSpacing: 0.0,
          color: effectiveColor,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }

    return textWidget;
  }
}

/// Custom secondary text widget with consistent typography
class CustomSecondaryText extends StatelessWidget {
  /// The text to display
  final String text;

  /// Custom text color (default: based on theme)
  final Color? color;

  /// Text alignment (default: center)
  final TextAlign? textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow? overflow;

  /// Whether the text should be selectable
  final bool selectable;

  /// Creates a new custom secondary text
  const CustomSecondaryText(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.onSurface;

    final textWidget = Text(
      text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400, // Regular
        fontSize: 16,
        height: 1.0, // 100% line height
        letterSpacing: 0.0,
        color: effectiveColor,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

    if (selectable) {
      return SelectableText(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400, // Regular
          fontSize: 16,
          height: 1.0, // 100% line height
          letterSpacing: 0.0,
          color: effectiveColor,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }

    return textWidget;
  }
}

/// Custom heading text widget with primary typography
class CustomHeading extends StatelessWidget {
  /// The text to display
  final String text;

  /// Custom text color (default: based on theme)
  final Color? color;

  /// Text alignment (default: start)
  final TextAlign? textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow? overflow;

  /// Whether the text should be selectable
  final bool selectable;

  /// Creates a new custom heading
  const CustomHeading(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) => CustomPrimaryText(
    text,
    color: color,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    selectable: selectable,
  );
}

/// Custom body text widget with secondary typography
class CustomBodyText extends StatelessWidget {
  /// The text to display
  final String text;

  /// Custom text color (default: based on theme)
  final Color? color;

  /// Text alignment (default: center)
  final TextAlign? textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow? overflow;

  /// Whether the text should be selectable
  final bool selectable;

  /// Creates a new custom body text
  const CustomBodyText(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) => CustomSecondaryText(
    text,
    color: color,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    selectable: selectable,
  );
}

/// Custom text widget with flexible typography options
class CustomText extends StatelessWidget {
  /// The text to display
  final String text;

  /// Text style variant
  final CustomTextStyle style;

  /// Custom text color (default: based on theme)
  final Color? color;

  /// Text alignment
  final TextAlign? textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow? overflow;

  /// Whether the text should be selectable
  final bool selectable;

  /// Creates a new custom text
  const CustomText(
    this.text, {
    super.key,
    this.style = CustomTextStyle.secondary,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case CustomTextStyle.primary:
        return CustomPrimaryText(
          text,
          color: color,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          selectable: selectable,
        );
      case CustomTextStyle.secondary:
        return CustomSecondaryText(
          text,
          color: color,
          textAlign: textAlign ?? TextAlign.center,
          maxLines: maxLines,
          overflow: overflow,
          selectable: selectable,
        );
    }
  }
}

/// Enum for custom text styles
enum CustomTextStyle {
  /// Primary text style (36px, Medium weight)
  primary,

  /// Secondary text style (16px, Regular weight)
  secondary,
}
