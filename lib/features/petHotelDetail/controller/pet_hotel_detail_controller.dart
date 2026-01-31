// // lib/features/petHotelDetail/presentation/controllers/pet_hotel_detail_controller.dart

// import 'package:get/get.dart';
// // ✅ ONLY import the CORRECT model
// import 'package:petzy_app/features/petHotel/data/model/pet_hotel_model.dart';
// import 'package:petzy_app/features/petHotelDetail/data/model/pet_hotel_detail_model.dart' hide PetHotel;

// class PetHotelDetailController extends GetxController {
//   late final PetHotel _hotel;
//   PetHotel get hotel => _hotel;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadHotelData();
//   }

//   void _loadHotelData() {
//     // ✅ REMOVED the extra 'tags: []' parameter
//     _hotel = PetHotel(
//       id: '1',
//       imageUrl: 'https://picsum.photos/400/225?random=1',
//       thumbnailUrls: [
//         'https://picsum.photos/60/60?random=1',
//         'https://picsum.photos/60/60?random=2',
//         'https://picsum.photos/60/60?random=3',
//         'https://picsum.photos/60/60?random=4',
//       ],
//       rating: 4.8,
//       reviewCount: 342,
//       title: 'Pawsome Paradise Resort',
//       tag: 'Pet Only + Human',
//       pricePerNight: 200,
//       provider: 'PetNutrition Co.',
//       location: 'Korea, Maharashtra',
//       description:
//           'Welcome to Pawsome Paradise Resort, a premium pet care facility designed to provide the best comfort and care for your beloved pets. Our experienced staff ensures your pets have a wonderful stay with us.',
//       amenities: ['AC Rooms', 'Play Area', 'Vet on Call', '24/7 Care'],
//       // roomType: RoomType(
//       //   title: 'Deluxe Suite',
//       //   roomName: 'Ocean View Room',
//       //   petCount: 2,
//       //   pricePerNight: 350,
//       // ),
//       foodOptions: [
//         FoodOption('Basic Meals', '2 meals/day - Standard pet food', 200),
//         FoodOption('Premium Meals', '3 meals/day - Premium ingredients', 400),
//         FoodOption('Custom Diet', 'Customized meal plan', 600),
//       ], tags: ['Pet Friendly', 'Family Owned', '24/7 Support'], roomType: '',
//     );
//   }

//   void onCardTapped() {
//     Get.snackbar('Info', 'Card tapped', snackPosition: SnackPosition.BOTTOM);
//   }

//   void onBookNowPressed() {
//     Get.snackbar('Success', 'Booking confirmed!', snackPosition: SnackPosition.BOTTOM);
//   }
// }