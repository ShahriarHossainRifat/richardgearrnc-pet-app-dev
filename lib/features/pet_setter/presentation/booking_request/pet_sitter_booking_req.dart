// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petzy_app/features/pet_setter/controller/pet_sitter_book_request_controller.dart';
import 'package:petzy_app/features/pet_setter/widgets/booking_card_list.dart';
import 'package:petzy_app/features/pet_setter/widgets/booking_constants.dart';
import 'package:petzy_app/features/pet_setter/widgets/booking_filter_grid.dart';
import 'package:petzy_app/features/pet_setter/widgets/booking_header.dart';
import 'package:petzy_app/features/pet_setter/widgets/booking_pill_tabs.dart';

import 'package:petzy_app/features/pet_setter/widgets/booking_section_card.dart';

class PetServicesBookingSearchPage extends GetView<PetSearchController> {
  const PetServicesBookingSearchPage({super.key});

  @override
  Widget build(final BuildContext context) {
    if (!Get.isRegistered<PetSearchController>()) {
      Get.put(PetSearchController());
    }

    return Scaffold(
      backgroundColor: petServicesBgLight,
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                Column(
                  children: [
                    PetServicesBookingHeader(
                      title: 'Find a Trusted Pet Sitter',
                      subtitle: 'Caring professionals near you',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCNXfY6ItwyvE4CUrC4Sd2eK1Ftm6Qh5iCjfuwSDc3rmMQrWAfXCFcIawBsuh4rgqpOS5p2n2BeQB5Dscj1gDMQVIriSrd9R-jw2BPvIhsEfOyVgby8yjhRGWj9XXRqzoURtCm2AuvnUKJWMhXgSFPSYCk8WtzC-bEp-dtcstuA5bIh5d-8xB7ZVyNF91wMeKyRr__H_TFrjTlTZ29KdWZjk00yAAfeQ0RAR5zpfUDyQJBAEy_fijdQffJ0CukjU7mpjor66rwfIIc',
                      onBack: controller.onBack,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 12),
                              PetServicesBookingPillTabs(controller: controller),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20),
                              //   child: Column(
                              //     children: [
                              //       PetServicesBookingSearchBar(
                              //         controller: controller.searchController,
                              //       ),
                              //       const SizedBox(height: 18),

                              //     ],
                              //   ),
                              // ),
                              SizedBox(height: 18),
                              PetServicesBookingSectionCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Row(
                                      children: [
                                        Icon(Icons.filter_list, size: 18, color: Color(0xFF6B7280)),
                                        SizedBox(width: 8),
                                        Text(
                                          'Filters',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 14),
                                    PetServicesBookingFilterGrid(),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 18),

                              // Tab content
                              Container(
                                height: MediaQuery.of(context).size.height * 0.65,
                                child: TabBarView(
                                  controller: controller.tabController,
                                  children: [
                                    Obx(
                                      () {
                                        if (controller.isLoadingServices.value) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        final error = controller.servicesError.value;
                                        if (error != null && error.isNotEmpty) {
                                          return Center(
                                            child: Text(
                                              error,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF6B7280),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }

                                        final items = controller.services.toList();
                                        if (items.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              'No services found.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF6B7280),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }

                                        return PetServicesBookingCardList(
                                          items: items,
                                          controller: controller,
                                          
                                        );
                                      },
                                    ),
                                    Obx(
                                      () {
                                        final items = controller.packages.toList();
                                        if (controller.isLoadingPackages.value) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        final error = controller.packagesError.value;
                                        if (error != null && error.isNotEmpty) {
                                          return Center(
                                            child: Text(
                                              error,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF6B7280),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }

                                        if (items.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              'No packages found.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF6B7280),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }

                                        return PetServicesBookingCardList(
                                          items: items,
                                          controller: controller,
                                          isPackage: true,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
