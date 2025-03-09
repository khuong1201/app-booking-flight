import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';

class WelcomePage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const WelcomePage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Image.asset(
            imagePath,
            width: 412,
            height: 411,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 28),
          Text(
            title,
            style: AppTextStyle.heading2Pri,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyle.body3,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
