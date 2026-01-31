import 'package:flutter/material.dart';
import 'package:petzy_app/core/constants/app_constants.dart';
import 'package:petzy_app/core/extensions/context_extensions.dart';

/// Modern animated tab bar with sliding indicator and smooth transitions.
///
/// Features:
/// - Sliding animated indicator
/// - Scale and opacity transitions on selection
/// - Icon and/or text label support
/// - Glassmorphism-style container option
///
/// Usage:
/// ```dart
/// AnimatedTabBar(
///   selectedIndex: _currentIndex,
///   onTabChanged: (index) => setState(() => _currentIndex = index),
///   tabs: [
///     AnimatedTabItem(icon: Icons.play_circle, label: 'Shorts'),
///     AnimatedTabItem(label: 'Home'),
///   ],
/// )
/// ```
class AnimatedTabBar extends StatefulWidget {
  /// Creates an [AnimatedTabBar].
  const AnimatedTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    super.key,
    this.height = 40,
    this.indicatorHeight = 3,
    this.useGlassmorphism = false,
    this.backgroundColor,
    this.indicatorColor,
    this.selectedLabelColor,
    this.unselectedLabelColor,
  });

  /// List of tab items to display.
  final List<AnimatedTabItem> tabs;

  /// Currently selected tab index.
  final int selectedIndex;

  /// Callback when tab selection changes.
  final ValueChanged<int> onTabChanged;

  /// Height of the tab bar.
  final double height;

  /// Height of the sliding indicator.
  final double indicatorHeight;

  /// Whether to apply glassmorphism styling.
  final bool useGlassmorphism;

  /// Background color override.
  final Color? backgroundColor;

  /// Indicator color override.
  final Color? indicatorColor;

  /// Selected label color override.
  final Color? selectedLabelColor;

  /// Unselected label color override.
  final Color? unselectedLabelColor;

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _indicatorAnimation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.selectedIndex;
    _controller = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );
    _indicatorAnimation = Tween<double>(
      begin: widget.selectedIndex.toDouble(),
      end: widget.selectedIndex.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(final AnimatedTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _previousIndex = oldWidget.selectedIndex;
      _indicatorAnimation =
          Tween<double>(
            begin: _previousIndex.toDouble(),
            end: widget.selectedIndex.toDouble(),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final bgColor = widget.backgroundColor ?? Colors.transparent;
    final indicatorColor = widget.indicatorColor ?? colorScheme.primary;
    final selectedColor = widget.selectedLabelColor ?? colorScheme.primary;
    final unselectedColor = widget.unselectedLabelColor ?? colorScheme.onSurfaceVariant;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMD),
      ),
      child: LayoutBuilder(
        builder: (final context, final constraints) {
          final tabWidth = constraints.maxWidth / widget.tabs.length;

          return Stack(
            children: [
              // Sliding indicator
              AnimatedBuilder(
                animation: _indicatorAnimation,
                builder: (final context, final child) {
                  return Positioned(
                    left: _indicatorAnimation.value * tabWidth,
                    bottom: 0,
                    child: Container(
                      width: tabWidth,
                      height: widget.indicatorHeight,
                      decoration: BoxDecoration(
                        color: indicatorColor,
                        borderRadius: BorderRadius.circular(
                          widget.indicatorHeight / 2,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Tabs row
              Row(
                children: List.generate(widget.tabs.length, (final index) {
                  final tab = widget.tabs[index];
                  final isSelected = index == widget.selectedIndex;

                  return Expanded(
                    child: _AnimatedTabButton(
                      tab: tab,
                      isSelected: isSelected,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                      textStyle: textTheme.labelLarge,
                      onTap: () => widget.onTabChanged(index),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnimatedTabButton extends StatefulWidget {
  const _AnimatedTabButton({
    required this.tab,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
    this.textStyle,
  });

  final AnimatedTabItem tab;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final TextStyle? textStyle;
  final VoidCallback onTap;

  @override
  State<_AnimatedTabButton> createState() => _AnimatedTabButtonState();
}

class _AnimatedTabButtonState extends State<_AnimatedTabButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: AppConstants.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final color = widget.isSelected ? widget.selectedColor : widget.unselectedColor;
    final fontWeight = widget.isSelected ? FontWeight.w600 : FontWeight.w500;

    return GestureDetector(
      onTapDown: (final _) => _scaleController.forward(),
      onTapUp: (final _) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedDefaultTextStyle(
          duration: AppConstants.animationFast,
          style: (widget.textStyle ?? const TextStyle()).copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.tab.icon != null) ...[
                  AnimatedScale(
                    scale: widget.isSelected ? 1.1 : 1.0,
                    duration: AppConstants.animationFast,
                    child: Icon(
                      widget.tab.icon,
                      size: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(widget.tab.label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Represents a single tab item in [AnimatedTabBar].
class AnimatedTabItem {
  /// Creates an [AnimatedTabItem].
  const AnimatedTabItem({
    required this.label,
    this.icon,
  });

  /// Text label for the tab.
  final String label;

  /// Optional icon displayed before the label.
  final IconData? icon;
}
