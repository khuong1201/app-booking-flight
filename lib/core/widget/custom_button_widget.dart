import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';

class CustomButton extends StatelessWidget {
  final String hintText;
  final String assetPath;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  const CustomButton({
    super.key,
    required this.hintText,
    required this.assetPath,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(assetPath, width: 20, height: 20),
              ),
              Expanded(
                child: Text(
                  hintText,
                  style: textStyle ?? const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 1.2, color: AppColors.neutralColor, height: 5),
        SizedBox(height: 8),
      ],
    );
  }
}
