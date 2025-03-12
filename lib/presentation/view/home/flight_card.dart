import 'package:booking_flight/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FlightCard extends StatelessWidget {
  final Map<String, String> flight;

  const FlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000), // rgba(0, 0, 0, 0.10)
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Ảnh đại diện của chuyến bay
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            child: Image.asset(
              flight["image"] ?? 'assets/Logo/Primiter.png',
              height: 79,
              width: 112,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 4,),
          /// Phần thông tin chuyến bay
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Lộ trình chuyến bay
                  if (flight["route"] != null && flight["route"]!.isNotEmpty)
                    Text(
                      flight["route"]!,
                      style: AppTextStyle.caption1,
                    ),
                  SizedBox(height: 4,),
                  /// Logo hãng bay + ngày bay
                  Row(
                    children: [
                      if (flight["logo"] != null && flight["logo"]!.isNotEmpty)
                        Image.asset(
                          flight["logo"]!,
                          width: 26,
                          height: 16,
                          fit: BoxFit.cover,
                        ),
                      SizedBox(width: 4),
                      Text(
                        flight["date"] ?? "Unknown Date",
                        style: AppTextStyle.caption2,
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  /// Giá chuyến bay
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (flight["oldPrice"] != null && flight["oldPrice"]!.isNotEmpty)
                        Text(
                          flight["oldPrice"]!,
                          style: AppTextStyle.caption1.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.neutralColor,
                            fontSize: 9,
                          ),
                        ),
                      SizedBox(height: 4,),
                      Text(
                        flight["newPrice"] ?? "Updating...",
                        style: AppTextStyle.paragraph2.copyWith(
                          color: AppColors.semanticColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
