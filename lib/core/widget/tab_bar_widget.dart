import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';

class CustomTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE3E8F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          buildTab("Round Trip", 0),
          buildTab("One-way Trip", 1),
        ],
      ),
    );
  }

  Widget buildTab(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: currentIndex == index
                    ? AppColors.primaryColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: currentIndex == index
                  ? AppColors.primaryColor
                  : AppColors.neutralColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}