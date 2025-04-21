import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('CustomBottomNavigationBar rebuild với currentIndex: $currentIndex');
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.neutralColor,
      backgroundColor: const Color(0xFFE3E8F7),
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/Airplane.png')),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/Trip.png')),
          label: 'Trips',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/Setting.png')),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/Profile.png')),
          label: 'Profile', // Sửa 'Profiles' thành 'Profile'
        ),
      ],
    );
  }
}