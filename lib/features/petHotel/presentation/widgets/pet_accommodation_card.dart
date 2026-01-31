import 'package:flutter/material.dart';

class PetAccommodationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double pricePerNight;
  final String roomType;
  final String location;
  final String provider;
  final List<String> tags;
  final VoidCallback onBookPressed;
  final Color primaryColor; 
  final Color textColor;
  final Color secondaryTextColor;
  final Color tagBackgroundColor;
  final Color tagTextColor;
  final BorderRadius? borderRadius;
  final double elevation;

  const PetAccommodationCard({
    final Key? key,
    required this.imageUrl,
    required this.title,
    required this.pricePerNight,
    required this.roomType,
    required this.location,
    required this.provider,
    required this.tags,
    required this.onBookPressed,
    this.primaryColor = const Color(0xFFFF6B6B),
    this.textColor = const Color(0xFF212121),
    this.secondaryTextColor = const Color(0xFF757575),
    this.tagBackgroundColor = const Color(0xFFF5F5F5),
    this.tagTextColor = const Color(0xFF616161),
    this.borderRadius,
    this.elevation = 4.0,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final radius = borderRadius ?? BorderRadius.circular(12.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: radius.topLeft),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, final __, final ___) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),

          // Tags Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildTags(),
          ),

          // Title & Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '\$${pricePerNight.toStringAsFixed(0)}/night',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Room Type
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Text(
              roomType,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: secondaryTextColor,
              ),
            ),
          ),

          // Location
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Color(0xFF9E9E9E)),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Provider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tagBackgroundColor,
                  ),
                  child: const Center(
                    child: Text(
                      'P',
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'By $provider',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF9E9E9E)),
              ],
            ),
          ),

          // Book Now Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: onBookPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 40),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Book Now'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    const int maxVisibleTags = 4;
    final visibleTags = tags.take(maxVisibleTags).toList();
    final overflowCount = tags.length - maxVisibleTags;

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        ...visibleTags.map((final tag) => _buildTag(tag)),
        if (overflowCount > 0) _buildTag('+$overflowCount'),
      ],
    );
  }

  Widget _buildTag(final String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: tagBackgroundColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: tagTextColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
