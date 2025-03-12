import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String assetPath;

  const CustomTextField({super.key, required this.hintText, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.asset(assetPath, width: 20, height: 20),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        Divider(thickness: 1, color: AppColors.neutralColor, height: 0),
        SizedBox(height: 10),
      ],
    );
  }
}
