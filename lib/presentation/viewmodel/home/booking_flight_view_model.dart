import 'package:flutter/material.dart';

class BookingFlightViewModel extends ChangeNotifier {
  int _tabIndex = 0;
  int _bottomNavIndex = 0;
  DateTime? _lastTapTime;

  int get tabIndex => _tabIndex;
  int get bottomNavIndex => _bottomNavIndex;

  void onTabTapped(int index) {
    if (_tabIndex != index) {
      _tabIndex = index;
      debugPrint('Chuyển tab: index=$index (0=Khứ hồi, 1=Một chiều)');
      notifyListeners();
    }
  }

  void onBottomNavTapped(int index) {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!).inMilliseconds < 300) {
      debugPrint('Bỏ qua tap nhanh: index=$index');
      return;
    }
    _lastTapTime = now;

    if (_bottomNavIndex == index) {
      debugPrint('Đã ở tab hiện tại: index=$index');
      return;
    }

    _bottomNavIndex = index;
    debugPrint('Cập nhật bottomNavIndex: $_bottomNavIndex');
    notifyListeners();
  }
}