// lib/features/petHotel/data/model/pet_hotel_model.dart

class PetHotel {
  final String id;
  final String imageUrl;
  final List<String> thumbnailUrls;
  final double rating;
  final int reviewCount;
  final String title;
  final String tag;
  final double pricePerNight;
  final String provider;
  final String location;
  final String description;
  final List<String> amenities;
  final RoomType roomType;
  final List<FoodOption> foodOptions;

  PetHotel({
    required this.id,
    required this.imageUrl,
    required this.thumbnailUrls,
    required this.rating,
    required this.reviewCount,
    required this.title,
    required this.tag,
    required this.pricePerNight,
    required this.provider,
    required this.location,
    required this.description,
    required this.amenities,
    required this.roomType,
    required this.foodOptions,
  });
}

class RoomType {
  final String title;
  final String roomName;
  final int petCount;
  final double pricePerNight;

  RoomType({
    required this.title,
    required this.roomName,
    required this.petCount,
    required this.pricePerNight,
  });
}

class FoodOption {
  final String title;
  final String description;
  final double price;

  FoodOption(this.title, this.description, this.price);
}