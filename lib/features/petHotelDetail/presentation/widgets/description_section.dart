import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  final String title;
  final String body;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? bodyColor;
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;
  final EdgeInsetsGeometry? padding;
  final double? lineHeight;
  final int? maxLines;
  final TextAlign? textAlign;

  const DescriptionSection({
    Key? key,
    required this.title,
    required this.body,
    this.backgroundColor = const Color(0xFFF8F9FA),
    this.titleColor = const Color(0xFF212121),
    this.bodyColor = const Color(0xFF424242),
    this.titleStyle,
    this.bodyStyle,
    this.padding,
    this.lineHeight,
    this.maxLines,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTitleStyle = titleStyle ??
        theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: titleColor,
          fontSize: 16,
        );
    final defaultBodyStyle = bodyStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: bodyColor,
          height: lineHeight ?? 1.5,
          fontSize: 14,
        );

    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: defaultTitleStyle,
          ),
          const SizedBox(height: 8),
          // Body
          Text(
            body,
            style: defaultBodyStyle,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : null,
          ),
        ],
      ),
    );
  }
}