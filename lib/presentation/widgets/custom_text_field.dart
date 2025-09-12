import 'package:flutter/material.dart';

/// Custom text field widget with consistent styling across the app
class CustomTextField extends StatelessWidget {
  /// The controller for the text field
  final TextEditingController? controller;

  /// The label text for the text field
  final String? labelText;

  /// The hint text for the text field
  final String? hintText;

  /// Whether the text field is obscure (for passwords)
  final bool obscureText;

  /// The keyboard type for the text field
  final TextInputType? keyboardType;

  /// The text input action for the text field
  final TextInputAction? textInputAction;

  /// The validator function for the text field
  final String? Function(String?)? validator;

  /// Callback when the field is submitted
  final void Function(String)? onFieldSubmitted;

  /// Callback when the text changes
  final void Function(String)? onChanged;

  /// Whether the text field is enabled
  final bool enabled;

  /// Whether the text field is read-only
  final bool readOnly;

  /// The maximum number of lines
  final int? maxLines;

  /// The maximum length of the text
  final int? maxLength;

  /// Custom width for the text field (default: 340)
  final double? width;

  /// Custom height for the text field (default: 54)
  final double? height;

  /// Custom border color (default: #E1E1E1)
  final Color? borderColor;

  /// Custom text color (default: based on theme)
  final Color? textColor;

  /// Custom hint text color (default: based on theme)
  final Color? hintTextColor;

  /// Custom border radius (default: 8)
  final double? borderRadius;

  /// Custom border width (default: 1)
  final double? borderWidth;

  /// Custom fill color for the text field
  final Color? fillColor;

  /// Prefix icon for the text field
  final IconData? prefixIcon;

  /// Suffix icon for the text field
  final Widget? suffixIcon;

  /// Whether to show a clear button
  final bool showClearButton;

  /// Creates a new custom text field
  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.hintTextColor,
    this.borderRadius,
    this.borderWidth,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveWidth = width ?? 340.0;
    final effectiveHeight = height ?? 54.0;
    final effectiveBorderColor = borderColor ?? const Color(0xFFE1E1E1);
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;
    final effectiveHintTextColor =
        hintTextColor ?? theme.colorScheme.onSurfaceVariant;
    final effectiveBorderRadius = borderRadius ?? 8.0;
    final effectiveBorderWidth = borderWidth ?? 1.0;
    final effectiveFillColor = fillColor ?? theme.colorScheme.surface;

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        enabled: enabled,
        readOnly: readOnly,
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          height: 1.0, // 100% line height
          letterSpacing: 0.0,
          color: effectiveTextColor,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1.0, // 100% line height
            letterSpacing: 0.0,
            color: effectiveHintTextColor,
          ),
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1.0, // 100% line height
            letterSpacing: 0.0,
            color: effectiveHintTextColor,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, size: 20, color: effectiveHintTextColor)
              : null,
          suffixIcon: _buildSuffixIcon(context, effectiveHintTextColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            borderSide: BorderSide(
              color: effectiveBorderColor,
              width: effectiveBorderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            borderSide: BorderSide(
              color: effectiveBorderColor,
              width: effectiveBorderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: effectiveBorderWidth,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: effectiveBorderWidth,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: effectiveBorderWidth,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            borderSide: BorderSide(
              color: effectiveBorderColor.withOpacity(0.5),
              width: effectiveBorderWidth,
            ),
          ),
          filled: true,
          fillColor: enabled
              ? effectiveFillColor
              : effectiveFillColor.withOpacity(0.5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          counterText: '', // Hide character counter
        ),
      ),
    );
  }

  /// Builds the suffix icon based on the widget configuration
  Widget? _buildSuffixIcon(BuildContext context, Color iconColor) {
    if (suffixIcon != null) {
      return suffixIcon;
    }

    if (showClearButton && controller != null && controller!.text.isNotEmpty) {
      return IconButton(
        icon: Icon(Icons.clear, size: 20, color: iconColor),
        onPressed: () {
          controller!.clear();
        },
      );
    }

    return null;
  }
}

/// Custom password text field with show/hide toggle
class CustomPasswordTextField extends StatefulWidget {
  /// The controller for the text field
  final TextEditingController? controller;

  /// The label text for the text field
  final String? labelText;

  /// The hint text for the text field
  final String? hintText;

  /// The validator function for the text field
  final String? Function(String?)? validator;

  /// Callback when the field is submitted
  final void Function(String)? onFieldSubmitted;

  /// Callback when the text changes
  final void Function(String)? onChanged;

  /// Whether the text field is enabled
  final bool enabled;

  /// Custom width for the text field (default: 340)
  final double? width;

  /// Custom height for the text field (default: 54)
  final double? height;

  /// Custom border color (default: #E1E1E1)
  final Color? borderColor;

  /// Custom text color (default: based on theme)
  final Color? textColor;

  /// Custom hint text color (default: based on theme)
  final Color? hintTextColor;

  /// Custom border radius (default: 8)
  final double? borderRadius;

  /// Custom border width (default: 1)
  final double? borderWidth;

  /// Custom fill color for the text field
  final Color? fillColor;

  /// Creates a new custom password text field
  const CustomPasswordTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.enabled = true,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.hintTextColor,
    this.borderRadius,
    this.borderWidth,
    this.fillColor,
  });

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) => CustomTextField(
    controller: widget.controller,
    labelText: widget.labelText,
    hintText: widget.hintText,
    obscureText: !_isPasswordVisible,
    keyboardType: TextInputType.visiblePassword,
    textInputAction: TextInputAction.done,
    validator: widget.validator,
    onFieldSubmitted: widget.onFieldSubmitted,
    onChanged: widget.onChanged,
    enabled: widget.enabled,
    width: widget.width,
    height: widget.height,
    borderColor: widget.borderColor,
    textColor: widget.textColor,
    hintTextColor: widget.hintTextColor,
    borderRadius: widget.borderRadius,
    borderWidth: widget.borderWidth,
    fillColor: widget.fillColor,
    prefixIcon: Icons.lock_outlined,
    suffixIcon: IconButton(
      icon: Icon(
        _isPasswordVisible
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        size: 20,
      ),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    ),
  );
}
