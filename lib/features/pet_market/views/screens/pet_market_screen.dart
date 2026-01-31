import 'package:flutter/material.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';

class PetMarketScreen extends StatelessWidget {
  const PetMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(112),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 112,
          width: double.maxFinite,
          color: AppColors.primary.withOpacity(0.2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.arrow_back_rounded, size: 25),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Find a Trusted Pet Sitter',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Caring professionals near you',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF828282),
                    ),
                  ),
                ],
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.shopping_cart_sharp, size: 24, color: Colors.white,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
