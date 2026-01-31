import 'package:flutter/material.dart';


class SegmentedFilter extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;
  final Color selectedBackgroundColor;
  final Color selectedTextColor;
  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;
  final Color unselectedTextColor;
  final double cornerRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? itemTextStyle;

  const SegmentedFilter({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
    this.onChanged,
    this.selectedBackgroundColor = const Color(0xFFFF6B6B),
    this.selectedTextColor = Colors.white,
    this.unselectedBackgroundColor = Colors.white,
    this.unselectedBorderColor = const Color(0xFFE0E0E0),
    this.unselectedTextColor = const Color(0xFF333333),
    this.cornerRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.itemTextStyle,
  }) : super(key: key);

  @override
  State<SegmentedFilter> createState() => _SegmentedFilterState();
}

class _SegmentedFilterState extends State<SegmentedFilter> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SegmentedFilter oldWidget) {
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      setState(() {
        _selectedIndex = widget.selectedIndex;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onTap(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.items.length;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), 
        borderRadius: BorderRadius.circular(widget.cornerRadius),
      ),
      child: Row(
        children: List.generate(itemCount, (index) {
          final isSelected = index == _selectedIndex;
          final isFirst = index == 0;
          final isLast = index == itemCount - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () => _onTap(index),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? widget.selectedBackgroundColor : widget.unselectedBackgroundColor,
                  border: Border(
                    left: !isFirst
                        ? BorderSide(color: widget.unselectedBorderColor, width: 1.0)
                        : BorderSide.none,
                    right: !isLast
                        ? BorderSide(color: widget.unselectedBorderColor, width: 1.0)
                        : BorderSide.none,
                  ),
                  borderRadius: _getBorderRadius(isFirst, isLast),
                ),
                padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Center(
                  child: Text(
                    widget.items[index],
                    style: (widget.itemTextStyle ??
                            theme.textTheme.labelMedium?.copyWith(
                              color: isSelected ? widget.selectedTextColor : widget.unselectedTextColor,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ))!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  BorderRadius _getBorderRadius(bool isFirst, bool isLast) {
    if (isFirst && isLast) {
      return BorderRadius.circular(widget.cornerRadius);
    } else if (isFirst) {
      return BorderRadius.only(
        topLeft: Radius.circular(widget.cornerRadius),
        bottomLeft: Radius.circular(widget.cornerRadius),
      );
    } else if (isLast) {
      return BorderRadius.only(
        topRight: Radius.circular(widget.cornerRadius),
        bottomRight: Radius.circular(widget.cornerRadius),
      );
    } else {
      return BorderRadius.zero;
    }
  }
}