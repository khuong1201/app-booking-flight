import 'package:flutter/material.dart';

class PassengerSelectionViewModel extends ChangeNotifier {
  int adultCount = 0;
  int childCount = 0;
  int infantCount = 0;

  int get totalPassengers => adultCount + childCount + infantCount;

  void updateAdultCount(int value) {
    if (adultCount != value) {
      adultCount = value;
      notifyListeners();
    }
  }

  void updateChildCount(int value) {
    if (childCount != value) {
      childCount = value;
      notifyListeners();
    }
  }

  void updateInfantCount(int value) {
    if (infantCount != value) {
      infantCount = value;
      notifyListeners();
    }
  }

  // Các điều kiện kiểm tra
  String? validatePassengers() {
    if (totalPassengers > 9) {
      return 'Tổng số hành khách không được vượt quá 9.';
    }

    if (infantCount > adultCount) {
      return 'Số lượng trẻ sơ sinh không thể lớn hơn số lượng người lớn.';
    }

    if (adultCount < 0 || childCount < 0 || infantCount < 0) {
      return 'Số lượng hành khách không được âm.';
    }

    if (infantCount > 0 && adultCount == 0) {
      return 'Phải có người lớn đi kèm trẻ sơ sinh';
    }

    return null;
  }
}