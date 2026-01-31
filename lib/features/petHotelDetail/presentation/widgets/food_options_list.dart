import 'package:flutter/material.dart';

class FoodOptionsList extends StatelessWidget {
  final String title;
  final List<FoodOption> options;
  final Color? titleColor;
  final Color? optionTitleColor;
  final Color? optionDescriptionColor;
  final Color? priceColor;
  final TextStyle? titleStyle;
  final TextStyle? optionTitleStyle;
  final TextStyle? optionDescriptionStyle;
  final TextStyle? priceStyle;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? itemSpacing;

  const FoodOptionsList({
    Key? key,
    required this.title,
    required this.options,
    this.titleColor = const Color(0xFF757575),
    this.optionTitleColor = const Color(0xFF212121),
    this.optionDescriptionColor = const Color(0xFF757575),
    this.priceColor = const Color(0xFFFF6B6B),
    this.titleStyle,
    this.optionTitleStyle,
    this.optionDescriptionStyle,
    this.priceStyle,
    this.padding,
    this.borderRadius,
    this.backgroundColor = Colors.white,
    this.borderColor,
    this.itemSpacing = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTitleStyle = titleStyle ??
        theme.textTheme.labelSmall?.copyWith(
          color: titleColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        );
    final defaultOptionTitleStyle = optionTitleStyle ??
        theme.textTheme.titleMedium?.copyWith(
          color: optionTitleColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        );
    final defaultOptionDescriptionStyle = optionDescriptionStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: optionDescriptionColor,
          fontSize: 13,
        );
    final defaultPriceStyle = priceStyle ??
        theme.textTheme.titleMedium?.copyWith(
          color: priceColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(title, style: defaultTitleStyle),
        const SizedBox(height: 12),
        // Options list
        ...List.generate(
          options.length,
          (index) {
            final option = options[index];
            return Container(
              padding: padding ?? const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius ?? BorderRadius.circular(12.0),
                border: borderColor != null
                    ? Border.all(color: borderColor!, width: 1.0)
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Title + Description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(option.title, style: defaultOptionTitleStyle),
                        const SizedBox(height: 4),
                        Text(
                          option.description,
                          style: defaultOptionDescriptionStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Right: Price
                  Text(
                    '+\$${option.price.toStringAsFixed(0)}/day',
                    style: defaultPriceStyle,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Data class for a single food option
class FoodOption {
  final String title;
  final String description;
  final double price; // e.g., 200 for +$200/day

  FoodOption(this.title, this.description, this.price);
}