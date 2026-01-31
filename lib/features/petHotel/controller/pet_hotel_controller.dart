// // lib/features/petHotel/presentation/controllers/pet_hotel_controller.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:petzy_app/features/petHotel/data/model/pet_hotel_model.dart';

// class PetHotelController extends GetxController {
//   // Search
//   final searchController = TextEditingController();
//   final RxString _searchQuery = ''.obs;
//   String get searchQuery => _searchQuery.value;
//   set searchQuery(final String value) => _searchQuery.value = value;

//   // Filter
//   final RxInt _selectedIndex = 0.obs;
//   int get selectedIndex => _selectedIndex.value;
//   set selectedIndex(final int value) => _selectedIndex.value = value;

//   // Hotels data
//   final RxList<PetHotel> _hotels = <PetHotel>[].obs;
//   List<PetHotel> get hotels => _hotels;

//   // Initialize with mock data (replace with API call later)
//   @override
//   void onInit() {
//     super.onInit();
//     _loadHotels();
//     _listenToSearch();
//   }

//   void _loadHotels() {
//     _hotels.assignAll([
//       PetHotel(
//         id: '1',
//         imageUrl: 'https://picsum.photos/400/225?random=1',
//         title: 'Pawsome Paradise',
//         pricePerNight: 200,
//         roomType: 'Single Room',
//         location: 'Korea, Maharashtra',
//         provider: 'PetNutrition Co.',
//         tags: ['AC Rooms', 'Play Area', 'Foods', 'WiFi', 'Pool', 'Spa'], foodOptions: null, amenities: [], thumbnailUrls: [], rating: null, reviewCount: null, tag: '', description: '',
//       ),
//       PetHotel(
//         id: '2',
//         imageUrl: 'https://picsum.photos/400/225?random=2',
//         title: 'Furry Haven',
//         pricePerNight: 180,
//         roomType: 'Double Room',
//         location: 'Seoul, South Korea',
//         provider: 'PetCare Experts',
//         tags: ['Garden', 'Pet Spa', '24/7 Care', 'Organic Food'], 
//         foodOptions: null, amenities: [], thumbnailUrls: [], rating: null, reviewCount: null, 
//         tag: '', 
//         description: '',
//       ),
//     ]);
//   }

//   void _listenToSearch() {
//     // Debounce search input
//     searchController.addListener(() {
//       searchQuery = searchController.text;
//       update(); // Trigger UI rebuild
//     });
//   }

//   void onFilterChanged(final int index) {
//     selectedIndex = index;
//   }

//   void onBookPressed(final PetHotel hotel) {
//     // Handle booking logic here
//     Get.snackbar(
//       'Booking Initiated',
//       '${hotel.title} selected for booking',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }

//   @override
//   void onClose() {
//     searchController.dispose();
//     super.onClose();
//   }
// }


// lib/controllers/pet_hotel_controller.dart
import 'package:get/get.dart';
import 'package:petzy_app/features/petHotel/data/model/pet_hotel_model.dart';
import 'package:petzy_app/features/petHotel/data/service/pet_hotel_service.dart';


class PetHotelController extends GetxController {
  final PetHotelService _service = PetHotelService();

  final RxList<PetHotel> hotels = <PetHotel>[].obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  // Example: assume you have a way to get token (e.g., from secure storage)
  // For demo, pass token when calling fetch
  Future<void> fetchHotels(String token) async {
    try {
      loading.value = true;
      error.value = '';

      final response = await _service.fetchPetHotels(token);
      if (response.success) {
        hotels.assignAll(response.data);
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

