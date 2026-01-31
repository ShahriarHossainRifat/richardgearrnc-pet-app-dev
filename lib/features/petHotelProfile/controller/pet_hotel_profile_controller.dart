// lib/controllers/pet_hotel_profile_controller.dart
import 'package:get/get.dart';
import 'package:petzy_app/features/petHotelProfile/data/model/pet_hotel_profile_model.dart';
import 'package:petzy_app/features/petHotelProfile/data/service/pet_hotel_profile_service.dart';


class PetHotelProfileController extends GetxController {
  final PetHotelProfileService _service = PetHotelProfileService();

  final Rx<PetHotelProfile?> profile = Rx<PetHotelProfile?>(null);
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  Future<void> fetchProfile(String token) async {
    try {
      loading.value = true;
      error.value = '';

      final response = await _service.fetchProfile(token);
      if (response.success && response.data != null) {
        profile.value = response.data;
      } else {
        error.value = response.message;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }
}