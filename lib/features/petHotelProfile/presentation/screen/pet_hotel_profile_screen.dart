// lib/screens/pet_hotel_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petzy_app/features/petHotelProfile/controller/pet_hotel_profile_controller.dart';
import 'package:petzy_app/features/petHotelProfile/data/model/pet_hotel_profile_model.dart';


class PetHotelProfileScreen extends StatelessWidget {
  final String authToken;

  const PetHotelProfileScreen({super.key, required this.authToken});

  @override
  Widget build(BuildContext context) {
    // Manual controller creation (no Bindings)
    final controller = Get.put(PetHotelProfileController());

    // Fetch once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfile(authToken);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet Hotel Profile')),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text('Error: ${controller.error.value}'));
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('No profile data'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Email: ${profile.email}'),
              Text('Phone: ${profile.phone}'),
              Text('Status: ${profile.status}'),
              const SizedBox(height: 12),
              if (profile.images.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    profile.images[0],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 12),
              Text('Description:\n${profile.description}'),
              const SizedBox(height: 16),
              if (profile.addresses.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Addresses:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    for (var address in profile.addresses)
                      AddressCard(address: address),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }
}

// Purely presentational
class AddressCard extends StatelessWidget {
  final Address address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(address.streetAddress),
            Text('${address.city}, ${address.country}'),
            Text('Postal Code: ${address.postalCode}'),
          ],
        ),
      ),
    );
  }
}