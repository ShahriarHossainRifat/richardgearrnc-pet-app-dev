// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:petzy_app/features/pet_setter/controller/pet_sitter_book_request_controller.dart';
import 'package:petzy_app/features/pet_setter/widgets/service_card.dart';

class PetServicesBookingCardList extends StatelessWidget {
  const PetServicesBookingCardList({
    required this.items,
    required this.controller,
    this.isPackage = false,
    super.key,
  });

  final List<ServiceItem> items;
  final PetSearchController controller;
  final bool isPackage;

  @override
  Widget build(final BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, final __) => const SizedBox(height: 14),
      itemBuilder: (final context, final i) {
        final it = items[i];
        return ServiceCard(
          item: it,
          onBook: () => controller.onBook(it),
          onMessage: () => controller.onMessage(it),
          onProviderTap: () => controller.onProviderTap(it),
          onView:
              () =>
                  isPackage
                      ? controller.onViewPackage(context, it)
                      : controller.onView(context, it),
        );
      },
    );
  }
}
