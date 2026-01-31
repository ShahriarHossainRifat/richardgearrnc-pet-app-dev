// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:petzy_app/features/pet_setter/controller/pet_sitter_book_request_controller.dart';
import 'package:petzy_app/features/pet_setter/widgets/booking_constants.dart';

class PetServicesBookingPillTabs extends StatelessWidget {
  const PetServicesBookingPillTabs({required this.controller, super.key});
  final PetSearchController controller;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 2),
            color: Color(0x0D000000),
          ),
        ],
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: controller.tabController,
        indicator: BoxDecoration(
          color: petServicesPrimary,
          borderRadius: BorderRadius.circular(999),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF9CA3AF),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Services'),
          Tab(text: 'Packages'),
        ],
      ),
    );
  }
}
