// // lib/features/petHotel/data/models/pet_hotel_model.dart

// class PetHotel {
//   final String id;
//   final String imageUrl;
//   final String title;
//   final double pricePerNight;
//   final String roomType;
//   final String location;
//   final String provider;
//   final List<String> tags;

//   PetHotel({
//     required this.id,
//     required this.imageUrl,
//     required this.title,
//     required this.pricePerNight,
//     required this.roomType,
//     required this.location,
//     required this.provider, required this.tags, required foodOptions, required List<dynamic> amenities, required List<dynamic> thumbnailUrls, required rating, required reviewCount, required String tag, required String description,
//   });
// }



// lib/models/pet_hotel_model.dart
class PetHotelResponse {
  final bool success;
  final String message;
  final List<PetHotel> data;

  PetHotelResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PetHotelResponse.fromJson(Map<String, dynamic> json) {
    return PetHotelResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List?)
              ?.map((e) => PetHotel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PetHotel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String description;
  final List<String> images;
  final String dayStartingTime;
  final String dayEndingTime;
  final String nightStartingTime;
  final String nightEndingTime;
  final String status;
  final bool isVerified;
  final int rating;
  final int reviewCount;
  final dynamic analytics; // null in your example
  final DateTime createdAt;
  final DateTime updatedAt;

  PetHotel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.description,
    required this.images,
    required this.dayStartingTime,
    required this.dayEndingTime,
    required this.nightStartingTime,
    required this.nightEndingTime,
    required this.status,
    required this.isVerified,
    required this.rating,
    required this.reviewCount,
    required this.analytics,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PetHotel.fromJson(Map<String, dynamic> json) {
    return PetHotel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      description: json['description'] as String,
      images: (json['images'] as List?)
              ?.map((e) => e.toString().trim())
              .toList() ??
          [],
      dayStartingTime: json['dayStartingTime'] as String,
      dayEndingTime: json['dayEndingTime'] as String,
      nightStartingTime: json['nightStartingTime'] as String,
      nightEndingTime: json['nightEndingTime'] as String,
      status: json['status'] as String,
      isVerified: json['isVerified'] as bool,
      rating: json['rating'] as int,
      reviewCount: json['reviewCount'] as int,
      analytics: json['analytics'],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}