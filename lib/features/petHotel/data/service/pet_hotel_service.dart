// lib/services/pet_hotel_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petzy_app/features/petHotel/data/model/pet_hotel_model.dart';


class PetHotelService {
  static const String baseUrl = 'https://clever-iguana-terminally.ngrok-free.app';

  Future<PetHotelResponse> fetchPetHotels(String token) async {
    final url = Uri.parse('$baseUrl/api/pet-hotel');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PetHotelResponse.fromJson(json);
    } else {
      throw Exception('Failed to load pet hotels: ${response.statusCode}');
    }
  }
}