import 'package:flutter/material.dart';

class PassengerSelectionViewModel extends ChangeNotifier {
  int _adultCount;
  int _childCount;
  int _infantCount;

  PassengerSelectionViewModel({
    int initialAdults = 1,
    int initialChilds = 0,
    int initialInfants = 0,
  })  : _adultCount = initialAdults,
        _childCount = initialChilds,
        _infantCount = initialInfants;

  int get adultCount => _adultCount;
  int get childCount => _childCount;
  int get infantCount => _infantCount;

  int get totalPassengers => _adultCount + _childCount + _infantCount;

  void updateAdultCount(int value) {
    if (value >= 1 && value != _adultCount) {
      _adultCount = value;
      print('Updated adult count: $_adultCount'); // Debugging print
      notifyListeners();
    }
  }

  void updateChildCount(int value) {
    if (value >= 0 && value != _childCount) {
      _childCount = value;
      print('Updated child count: $_childCount'); // Debugging print
      notifyListeners();
    }
  }

  void updateInfantCount(int value) {
    if (value >= 0 && value != _infantCount) {
      _infantCount = value;
      print('Updated infant count: $_infantCount'); // Debugging print
      notifyListeners();
    }
  }

  String? validatePassengers() {
    final validationResult = totalPassengers > 9
        ? 'Tổng số hành khách không được vượt quá 9.'
        : _infantCount > _adultCount
        ? 'Số lượng trẻ sơ sinh không thể lớn hơn số lượng người lớn.'
        : _adultCount < 1
        ? 'Phải có ít nhất 1 người lớn.'
        : null;

    print('Validation result: $validationResult'); // Debugging print
    return validationResult;
  }

  Map<String, int> getPassengerSelection() {
    final selection = {
      'adults': _adultCount,
      'childs': _childCount,
      'infants': _infantCount,
    };
    print('Passenger selection: $selection'); // Debugging print
    return selection;
  }
}
