
import 'package:flutter/material.dart';
import 'package:petzy_app/core/widgets/buttons.dart';
import 'package:petzy_app/features/petHotel/presentation/widgets/custom_app_bar.dart';
import 'package:petzy_app/features/petHotelDetail/presentation/widgets/amenities_list.dart';
import 'package:petzy_app/features/petHotelDetail/presentation/widgets/compact_pet_accommodation_card.dart';
import 'package:petzy_app/features/petHotelDetail/presentation/widgets/description_section.dart';
import 'package:petzy_app/features/petHotelDetail/presentation/widgets/food_options_list.dart';
import 'package:petzy_app/features/petHotelDetail/presentation/widgets/room_type_card.dart';

class PetHotelDetailScreen extends StatelessWidget {
  const PetHotelDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: "Pet Hotel Booking",
                onBack: () => Navigator.pop(context),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CompactPetAccommodationCard(
                  imageUrl: 'https://picsum.photos/400/225?random=1  ',
                  thumbnailUrls: [
                    'https://picsum.photos/60/60?random=1  ',
                    'https://picsum.photos/60/60?random=2  ',
                    'https://picsum.photos/60/60?random=3  ',
                    'https://picsum.photos/60/60?random=4  ',
                  ],
                  rating: 4.8,
                  reviewCount: 342,
                  title: 'Pawsome Paradise Resort',
                  tag: 'Pet Only + Human',
                  pricePerNight: 200,
                  provider: 'PetNutrition Co.',
                  location: 'Korea, Maharashtra',
                  onTap: () => () {},
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DescriptionSection(
                  title: 'Description',
                  body:
                      'Welcome to Pawsome Paradise Resort, a premium pet care facility designed to provide the best comfort and care for your beloved pets. Our experienced staff ensures your pets have a wonderful stay with us.',
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AmenitiesList(
                  title: 'Amenities',
                  items: [
                    'AC Rooms',
                    'Play Area',
                    'Vet on Call',
                    '24/7 Care',
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RoomTypeCard(
                  title: 'Room Type',
                  roomName: 'Single Room',
                  petCount: 1,
                  pricePerNight: 1200,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FoodOptionsList(
                  title: 'Food Options',
                  options: [
                    FoodOption('Basic Meals', '2 meals/day - Standard pet food', 200),
                    FoodOption('Premium Meals', '3 meals/day - Premium ingredients', 400),
                    FoodOption('Custom Diet', 'Customized meal plan', 600),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              AppButton(
                onPressed: (){},
                label: 'Book Now'
                ),
            ],
          ),
        ),
      ),
    );
  }
}
