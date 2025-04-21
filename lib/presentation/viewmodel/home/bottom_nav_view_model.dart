import 'package:flutter/material.dart';

class BottomNavViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onBottomNavTapped(int index, BuildContext context) {
    if (currentIndex != index) {
    _currentIndex = index;
    notifyListeners();
    // Điều hướng đến route tương ứng
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/Home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/Trips');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      }
    }
  }
}