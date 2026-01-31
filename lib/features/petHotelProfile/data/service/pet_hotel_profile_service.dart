// lib/services/pet_hotel_profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petzy_app/features/petHotelProfile/data/model/pet_hotel_profile_model.dart';


class PetHotelProfileService {
  Future<PetHotelProfileResponse> fetchProfile(String token) async {
    final url = Uri.parse(
        'https://clever-iguana-terminally.ngrok-free.app/api/pet-hotel/profile');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PetHotelProfileResponse.fromJson(json);
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }
}