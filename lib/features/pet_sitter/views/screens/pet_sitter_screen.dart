import 'package:flutter/material.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/pet_sitter/views/screens/service_details.dart';
import 'package:petzy_app/features/pet_sitter/views/widgets/service_card.dart';

class PetSitterScreen extends StatelessWidget {
  const PetSitterScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 112,
          width: double.maxFinite,
          color: AppColors.primary.withOpacity(0.2),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Padding(padding: EdgeInsets.only(left: 10)),
              Icon(
                Icons.arrow_back_rounded,
                size: 25,
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find a Trusted Pet Sitter',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    'Caring professionals near you',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF828282),
                    ),
                  ),
                ],
              ),

              Image.asset(
                Assets.dogImage,
                height: 40,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 20),

              // 1. Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for providers, services, ect...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Toggle Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE97676),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Services',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Packages',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF5F6368),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Filters Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.filter_list_outlined,
                          color: Color(0xFF5F6368),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Important
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.5,
                      children: [
                        _buildFilterChip('Availability'),
                        _buildFilterChip('Max Price'),
                        _buildFilterChip('Rating'),
                        _buildFilterChip('Location'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. List View (Modified to scroll with the Column)
              ListView.builder(
                shrinkWrap:
                    true, // Allows the ListView to take only needed space
                physics:
                    const NeverScrollableScrollPhysics(), // Disables nested scrolling
                itemCount: 10,
                itemBuilder: (final context, final index) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ), // Add space between cards
                  child: ServiceProviderCard(
                    imageUrl: "https://placehold.co/100x100/png",
                    serviceName: "Full Grooming",
                    rating: 4.4,
                    reviewCount: 30,
                    distance: 10,
                    price: "30",
                    providerName: 'Some',
                    providerLogoUrl: 'some',
                    onBookNow: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (final context) => ServiceDetails(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(final String label) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFF3C4043), fontSize: 15),
      ),
    );
  }
}
