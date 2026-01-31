// // lib/features/petHotel/presentation/screens/pet_hotel_screen.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:petzy_app/features/petHotel/controller/pet_hotel_controller.dart';
// import 'package:petzy_app/features/petHotel/presentation/widgets/sgemented_filter.dart';
// import '../widgets/custom_app_bar.dart';
// import '../widgets/search_bar.dart';
// import '../widgets/pet_accommodation_card.dart';

// class PetHotelScreen extends StatelessWidget {
//   PetHotelScreen({final Key? key}) : super(key: key);

//   final controller = Get.put(PetHotelController());

//   @override
//   Widget build(final BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: EdgeInsets.zero,
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomAppBar(
//                 title: "Pet Hotel Booking",
//                 onBack: () => Navigator.pop(context),
//               ),
//               const SizedBox(height: 24),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: SearchBar1(
//                   placeholder: 'Search for providers, services, etc...',
//                   controller: controller.searchController,
//                   onChanged: (final value) {},
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: SegmentedFilter(
//                   items: ['All', 'Pet Only', 'Pet + Human'],
//                   selectedIndex: controller.selectedIndex,
//                   onChanged: controller.onFilterChanged,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               Obx(
//                 () => ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: controller.hotels.length,
//                   itemBuilder: (final context, final index) {
//                     final hotel = controller.hotels[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       child: PetAccommodationCard(
//                         imageUrl: hotel.imageUrl,
//                         title: hotel.title,
//                         pricePerNight: hotel.pricePerNight,
//                         roomType: hotel.roomType,
//                         location: hotel.location,
//                         provider: hotel.provider,
//                         tags: hotel.tags,
//                         onBookPressed: () => controller.onBookPressed(hotel),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// lib/screens/pet_hotel_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petzy_app/features/petHotel/controller/pet_hotel_controller.dart';
import 'package:petzy_app/features/petHotel/data/model/pet_hotel_model.dart';


// Dumb UI: only displays data, no logic
class PetHotelScreen extends StatelessWidget {
  final String authToken; // Pass token from parent (e.g., after login)

  const PetHotelScreen({super.key, required this.authToken});

  @override
  Widget build(BuildContext context) {
    // Manual controller creation (no Bindings)
    final controller = Get.put(PetHotelController());

    // Trigger fetch once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchHotels(authToken);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Pet Hotels')),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text('Error: ${controller.error.value}'));
        }

        return ListView.builder(
          itemCount: controller.hotels.length,
          itemBuilder: (context, index) {
            final hotel = controller.hotels[index];
            return PetHotelCard(hotel: hotel);
          },
        );
      }),
    );
  }
}

// Purely presentational widget
class PetHotelCard extends StatelessWidget {
  final PetHotel hotel;

  const PetHotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hotel.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Email: ${hotel.email}'),
            Text('Phone: ${hotel.phone}'),
            Text('Hours: ${hotel.dayStartingTime}–${hotel.dayEndingTime}'),
            if (hotel.images.isNotEmpty)
              Image.network(
                hotel.images[0],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 8),
            Text(hotel.description),
          ],
        ),
      ),
    );
  }
}