/// Enum representing different user roles in the application.
enum UserRole {
  /// Pet owner who books pet services
  petOwner,

  /// Pet sitter who provides pet sitting services
  petSitter,

  /// Pet school that offers training services
  petSchool,

  /// Pet hotel that provides boarding services
  petHotel,
  ;

  /// Get the user-friendly display name for the role.
  String get displayName => switch (this) {
    UserRole.petOwner => 'Pet Owner',
    UserRole.petSitter => 'Pet Sitter',
    UserRole.petSchool => 'Pet School',
    UserRole.petHotel => 'Pet Hotel',
  };

  /// Parse a string to UserRole.
  /// Returns null if the string doesn't match any role.
  static UserRole? fromString(final String? value) {
    if (value == null) return null;
    try {
      return UserRole.values.firstWhere(
        (final role) => role.name == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Convert to a JSON-compatible string representation.
  String toJsonString() => name;
}
