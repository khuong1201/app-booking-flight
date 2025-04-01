import 'package:flutter/material.dart';

class BookingFlightViewModel extends ChangeNotifier {
  int tabIndex = 0;
  int bottomNavIndex = 0;

  void onTabTapped(int index) {
    tabIndex = index;
    notifyListeners();
  }

  void onBottomNavTapped(int index) {
    bottomNavIndex = index;
    if (index == 0) tabIndex = 0;
    notifyListeners();
  }
}
