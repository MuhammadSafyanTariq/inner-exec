import 'package:flutter/material.dart';

/// Custom page indicator widget for onboarding screens
class PageIndicator extends StatelessWidget {
  /// Current page index (0-based)
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Color of the active indicator (default: #8B51FE)
  final Color? activeColor;

  /// Color of the inactive indicators (default: active color with 30% opacity)
  final Color? inactiveColor;

  /// Size of each indicator dot (default: 8)
  final double dotSize;

  /// Spacing between dots (default: 8)
  final double spacing;

  /// Callback when a dot is tapped
  final void Function(int page)? onPageTap;

  /// Creates a new page indicator
  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 8.0,
    this.spacing = 8.0,
    this.onPageTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? const Color(0xFF8B51FE);
    final effectiveInactiveColor =
        inactiveColor ?? effectiveActiveColor.withOpacity(0.3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => GestureDetector(
          onTap: onPageTap != null ? () => onPageTap!(index) : null,
          child: Container(
            margin: EdgeInsets.only(
              right: index < totalPages - 1 ? spacing : 0,
            ),
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: index == currentPage
                  ? effectiveActiveColor
                  : effectiveInactiveColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
