import 'package:flutter/material.dart';


class SearchBar1 extends StatelessWidget {
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final Color hintColor;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final double height;
  final IconData? icon;
  final TextStyle? placeholderStyle;
  final bool enabled;

  const SearchBar1({
    Key? key,
    this.placeholder = 'Search for providers, services, etc...',
    this.onChanged,
    this.onTap,
    this.controller,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.borderColor = Colors.transparent,
    this.iconColor = const Color(0xFF9E9E9E),
    this.textColor = Colors.black,
    this.hintColor = const Color(0xFF9E9E9E),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.height = 48,
    this.icon = Icons.search,
    this.placeholderStyle,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextStyle = theme.textTheme.bodyMedium?.copyWith(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        enabled: enabled,
        keyboardType: keyboardType ?? TextInputType.text,
        textCapitalization: textCapitalization,
        onChanged: onChanged,
        onTap: onTap,
        style: defaultTextStyle,
        decoration: InputDecoration(
          contentPadding: padding,
          hintText: placeholder,
          hintStyle: placeholderStyle ??
              defaultTextStyle?.copyWith(color: hintColor, fontSize: 16),
          filled: false,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: icon != null
              ? Icon(
                  icon!,
                  size: 20,
                  color: iconColor,
                )
              : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }
}