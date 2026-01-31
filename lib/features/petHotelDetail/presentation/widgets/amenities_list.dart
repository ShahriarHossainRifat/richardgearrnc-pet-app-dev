import 'package:flutter/material.dart';

class AmenitiesList extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color? iconColor;
  final Color? textColor;
  final TextStyle? titleStyle;
  final TextStyle? itemStyle;
  final EdgeInsetsGeometry? padding;
  final double? columnSpacing;
  final double? rowSpacing;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const AmenitiesList({
    Key? key,
    required this.title,
    required this.items,
    this.iconColor = const Color(0xFF4CAF50), // Material green 500
    this.textColor = const Color(0xFF333333),
    this.titleStyle,
    this.itemStyle,
    this.padding,
    this.columnSpacing = 16.0,
    this.rowSpacing = 8.0,
    this.borderRadius,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTitleStyle = titleStyle ??
        theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor,
          fontSize: 16,
        );
    final defaultItemStyle = itemStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontSize: 14,
        );

    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(title, style: defaultTitleStyle),
          const SizedBox(height: 12),
          // Amenities Grid
          Wrap(
            spacing: columnSpacing!,
            runSpacing: rowSpacing!,
            children: items.map((item) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: iconColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: defaultItemStyle,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}