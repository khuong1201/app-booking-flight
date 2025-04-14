import 'package:flutter/material.dart';

class PassengerSelectionViewModel extends ChangeNotifier {
  int _adultCount;
  int _childCount;
  int _infantCount;

  PassengerSelectionViewModel({
    int initialAdults = 1,
    int initialChildren = 0,
    int initialInfants = 0,
  })  : _adultCount = initialAdults,
        _childCount = initialChildren,
        _infantCount = initialInfants;

  int get adultCount => _adultCount;
  int get childCount => _childCount;
  int get infantCount => _infantCount;

  int get totalPassengers => _adultCount + _childCount + _infantCount;

  void updateAdultCount(int value) {
    if (value >= 1 && value != _adultCount) {
      _adultCount = value;
      notifyListeners();
    }
  }

  void updateChildCount(int value) {
    if (value >= 0 && value != _childCount) {
      _childCount = value;
      notifyListeners();
    }
  }

  void updateInfantCount(int value) {
    if (value >= 0 && value != _infantCount) {
      _infantCount = value;
      notifyListeners();
    }
  }

  String? validatePassengers() {
    if (totalPassengers > 9) {
      return 'Tổng số hành khách không được vượt quá 9.';
    }

    if (_infantCount > _adultCount) {
      return 'Số lượng trẻ sơ sinh không thể lớn hơn số lượng người lớn.';
    }

    if (_adultCount < 1) {
      return 'Phải có ít nhất 1 người lớn.';
    }

    return null;
  }

  Map<String, int> getPassengerSelection() {
    return {
      'adults': _adultCount,
      'children': _childCount,
      'infants': _infantCount,
    };
  }
}
