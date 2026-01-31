import 'package:flutter/material.dart';

class RoomTypeCard extends StatelessWidget {
  final String title;
  final String roomName;
  final int petCount;
  final double pricePerNight;
  final Color? titleColor;
  final Color? roomNameColor;
  final Color? petCountColor;
  final Color? priceColor;
  final Color? perNightColor;
  final TextStyle? titleStyle;
  final TextStyle? roomNameStyle;
  final TextStyle? petCountStyle;
  final TextStyle? priceStyle;
  final TextStyle? perNightStyle;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  const RoomTypeCard({
    Key? key,
    required this.title,
    required this.roomName,
    required this.petCount,
    required this.pricePerNight,
    this.titleColor = const Color(0xFF757575),
    this.roomNameColor = const Color(0xFF212121),
    this.petCountColor = const Color(0xFF757575),
    this.priceColor = const Color(0xFFFF6B6B),
    this.perNightColor = const Color(0xFF9E9E9E),
    this.titleStyle,
    this.roomNameStyle,
    this.petCountStyle,
    this.priceStyle,
    this.perNightStyle,
    this.padding,
    this.borderRadius,
    this.backgroundColor = Colors.white,
    this.borderColor,
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
    final defaultRoomNameStyle = roomNameStyle ??
        theme.textTheme.titleMedium?.copyWith(
          color: roomNameColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        );
    final defaultPetCountStyle = petCountStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: petCountColor,
          fontSize: 13,
        );
    final defaultPriceStyle = priceStyle ??
        theme.textTheme.titleLarge?.copyWith(
          color: priceColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        );
    final defaultPerNightStyle = perNightStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: perNightColor,
          fontSize: 12,
        );

    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.0)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(title, style: defaultTitleStyle),
          const SizedBox(height: 8),
          // Room Info + Price (row)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Room Name + Pet Count
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(roomName, style: defaultRoomNameStyle),
                  const SizedBox(height: 2),
                  Text('$petCount pet', style: defaultPetCountStyle),
                ],
              ),
              // Right: Price + Label
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${pricePerNight.toStringAsFixed(0)}', style: defaultPriceStyle),
                  const SizedBox(height: 2),
                  Text('per night', style: defaultPerNightStyle),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}