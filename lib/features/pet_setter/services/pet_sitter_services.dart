// ignore_for_file: public_member_api_docs

import 'package:dio/dio.dart';

class PetSitterService {
  PetSitterService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationInMinutes,
    required this.thumbnailImage,
    required this.whatsIncluded,
    required this.tags,
    required this.isAvailable,
  });

  final String id;
  final String name;
  final String description;
  final String price;
  final int? durationInMinutes;
  final String thumbnailImage;
  final List<String> whatsIncluded;
  final List<String> tags;
  final bool isAvailable;

  factory PetSitterService.fromJson(final Map<String, dynamic> json) {
    final whats = json['whatsIncluded'];
    final tags = json['tags'];

    return PetSitterService(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      durationInMinutes: json['durationInMinutes'] as int?,
      thumbnailImage: json['thumbnailImage']?.toString() ?? '',
      whatsIncluded: whats is List<dynamic>
          ? whats.map((final e) => e.toString()).toList()
          : const [],
      tags: tags is List<dynamic>
          ? tags.map((final e) => e.toString()).toList()
          : const [],
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }
}

class PetSitterProfileUser {
  PetSitterProfileUser({
    required this.id,
    required this.fullName,
    required this.image,
    this.email = '',
  });

  final String id;
  final String fullName;
  final String image;
  final String email;

  factory PetSitterProfileUser.fromJson(final Map<String, dynamic> json) {
    return PetSitterProfileUser(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class PetSitterProfile {
  PetSitterProfile({
    required this.userId,
    required this.status,
    required this.user,
  });

  final String userId;
  final String status;
  final PetSitterProfileUser? user;

  factory PetSitterProfile.fromJson(final Map<String, dynamic> json) {
    final userJson = json['user'];
    return PetSitterProfile(
      userId: json['userId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      user: userJson is Map<String, dynamic>
          ? PetSitterProfileUser.fromJson(userJson)
          : null,
    );
  }
}

class PetSitterDirectoryProfile {
  PetSitterDirectoryProfile({
    required this.id,
    required this.bio,
    required this.designations,
    required this.languages,
    required this.yearsOfExperience,
    required this.status,
    required this.user,
  });

  final String id;
  final String bio;
  final String designations;
  final List<String> languages;
  final int yearsOfExperience;
  final String status;
  final PetSitterProfileUser? user;

  factory PetSitterDirectoryProfile.fromJson(final Map<String, dynamic> json) {
    final languagesJson = json['languages'];
    final yearsValue = json['yearsOfExperience'];

    return PetSitterDirectoryProfile(
      id: json['id']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      designations: json['designations']?.toString() ?? '',
      languages: languagesJson is List<dynamic>
          ? languagesJson.map((final e) => e.toString()).toList()
          : const [],
      yearsOfExperience: yearsValue is int
          ? yearsValue
          : int.tryParse(yearsValue?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? '',
      user: json['user'] is Map<String, dynamic>
          ? PetSitterProfileUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PetSitterServiceDetails extends PetSitterService {
  PetSitterServiceDetails({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.durationInMinutes,
    required super.thumbnailImage,
    required super.whatsIncluded,
    required super.tags,
    required super.isAvailable,
    required this.petSitterProfile,
    required this.isOwner,
  });

  final PetSitterProfile? petSitterProfile;
  final bool isOwner;

  factory PetSitterServiceDetails.fromJson(final Map<String, dynamic> json) {
    final base = PetSitterService.fromJson(json);
    final profileJson = json['petSitterProfile'];

    return PetSitterServiceDetails(
      id: base.id,
      name: base.name,
      description: base.description,
      price: base.price,
      durationInMinutes: base.durationInMinutes,
      thumbnailImage: base.thumbnailImage,
      whatsIncluded: base.whatsIncluded,
      tags: base.tags,
      isAvailable: base.isAvailable,
      petSitterProfile: profileJson is Map<String, dynamic>
          ? PetSitterProfile.fromJson(profileJson)
          : null,
      isOwner: json['isOwner'] as bool? ?? false,
    );
  }
}

class PetSitterPackage {
  PetSitterPackage({
    required this.id,
    required this.name,
    required this.image,
    required this.offeredPrice,
    required this.calculatedPrice,
    required this.durationInMinutes,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String image;
  final String offeredPrice;
  final String calculatedPrice;
  final int? durationInMinutes;
  final String createdAt;

  factory PetSitterPackage.fromJson(final Map<String, dynamic> json) {
    return PetSitterPackage(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      offeredPrice: json['offeredPrice']?.toString() ?? '0',
      calculatedPrice: json['calculatedPrice']?.toString() ?? '0',
      durationInMinutes: json['durationInMinutes'] as int?,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class PetSitterPackageService {
  PetSitterPackageService({
    required this.id,
    required this.name,
    required this.price,
  });

  final String id;
  final String name;
  final String price;

  factory PetSitterPackageService.fromJson(final Map<String, dynamic> json) {
    return PetSitterPackageService(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
    );
  }
}

class PetSitterPackageAddon {
  PetSitterPackageAddon({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  final String id;
  final String name;
  final String price;
  final String description;

  factory PetSitterPackageAddon.fromJson(final Map<String, dynamic> json) {
    return PetSitterPackageAddon(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      description: json['description']?.toString() ?? '',
    );
  }
}

class PetSitterPackageDetails {
  PetSitterPackageDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.durationInMinutes,
    required this.calculatedPrice,
    required this.offeredPrice,
    required this.services,
    required this.addons,
    required this.isOwner,
  });

  final String id;
  final String name;
  final String description;
  final String image;
  final int? durationInMinutes;
  final String calculatedPrice;
  final String offeredPrice;
  final List<PetSitterPackageService> services;
  final List<PetSitterPackageAddon> addons;
  final bool isOwner;

  factory PetSitterPackageDetails.fromJson(final Map<String, dynamic> json) {
    final servicesJson = json['services'];
    final addonsJson = json['addons'];

    return PetSitterPackageDetails(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      durationInMinutes: json['durationInMinutes'] as int?,
      calculatedPrice: json['calculatedPrice']?.toString() ?? '0',
      offeredPrice: json['offeredPrice']?.toString() ?? '0',
      services: servicesJson is List<dynamic>
          ? servicesJson
                .whereType<Map<String, dynamic>>()
                .map(PetSitterPackageService.fromJson)
                .toList()
          : const [],
      addons: addonsJson is List<dynamic>
          ? addonsJson
                .whereType<Map<String, dynamic>>()
                .map(PetSitterPackageAddon.fromJson)
                .toList()
          : const [],
      isOwner: json['isOwner'] as bool? ?? false,
    );
  }
}

class PetSitterServicesApi {
  PetSitterServicesApi({final Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const String _baseUrl =
      'https://clever-iguana-terminally.ngrok-free.app/api';
  static const String _accessToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjkwZmY4MTBiLTBiM2EtNGYwYS05ZGJlLTdmNzVkZTY2MDg5OSIsImVtYWlsIjoiamloYWRtdWdkaG8xMjM2QGdtYWlsLmNvbSIsInJvbGUiOiJQRVRfU0lUVEVSIiwiaWF0IjoxNzY5ODQ3Mjg0LCJleHAiOjE3Njk5MzM2ODR9._julCeX93bctfznXnJbX2kEIxvCLRNQ6VOV6REnd-Y8';

  Future<List<PetSitterService>> fetchMyServices() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/services/me',
      options: Options(
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $_accessToken',
        },
      ),
    );

    final data = response.data;
    if (data == null) return [];

    final payload = data['data'];
    if (payload is! Map<String, dynamic>) return [];

    final items = payload['data'];
    if (items is! List<dynamic>) return [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(PetSitterService.fromJson)
        .toList();
  }

  Future<List<PetSitterPackage>> fetchMyPackages() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/pet-sitter-package/me',
      options: Options(
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $_accessToken',
        },
      ),
    );

    final data = response.data;
    if (data == null) return [];

    final payload = data['data'];
    if (payload is! Map<String, dynamic>) return [];

    final items = payload['data'];
    if (items is! List<dynamic>) return [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(PetSitterPackage.fromJson)
        .toList();
  }

  Future<PetSitterServiceDetails?> fetchServiceDetails(
    final String serviceId,
  ) async {
    if (serviceId.isEmpty) return null;

    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/services/$serviceId',
      options: Options(
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $_accessToken',
        },
      ),
    );

    final data = response.data;
    if (data == null) return null;

    final payload = data['data'];
    if (payload is! Map<String, dynamic>) return null;

    return PetSitterServiceDetails.fromJson(payload);
  }

  Future<PetSitterPackageDetails?> fetchPackageDetails(
    final String packageId,
  ) async {
    if (packageId.isEmpty) return null;

    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/pet-sitter-package/$packageId',
      options: Options(
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $_accessToken',
        },
      ),
    );

    final data = response.data;
    if (data == null) return null;

    final payload = data['data'];
    if (payload is! Map<String, dynamic>) return null;

    return PetSitterPackageDetails.fromJson(payload);
  }

  Future<List<PetSitterDirectoryProfile>> fetchPetSitterProfiles() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/pet-sitter',
      options: Options(
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $_accessToken',
        },
      ),
    );

    final data = response.data;
    if (data == null) return [];

    final payload = data['data'];
    if (payload is! Map<String, dynamic>) return [];

    final items = payload['data'];
    if (items is! List<dynamic>) return [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(PetSitterDirectoryProfile.fromJson)
        .toList();
  }
}
