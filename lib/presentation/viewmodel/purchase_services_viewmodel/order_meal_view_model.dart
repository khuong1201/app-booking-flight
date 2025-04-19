import 'package:booking_flight/data/meal_data.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/additional_services_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:flutter/material.dart';

class OrderMealViewModel extends ChangeNotifier {
  final FlightData flightData;
  final PassengerInfoViewModel passengerInfoViewModel;
  final AdditionalServicesViewModel additionalServicesViewModel;
  List<Map<String, dynamic>> mealSelections = [];

  OrderMealViewModel({
    required this.flightData,
    required this.passengerInfoViewModel,
    required this.additionalServicesViewModel,
  }) {
    _initMealSelections();
  }

  void _initMealSelections() {
    mealSelections = passengerInfoViewModel.passengers
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final service = additionalServicesViewModel.additionalServices[index];
      return {
        'passengerIndex': index,
        'passengerName': passengerInfoViewModel.getFullName(index),
        'meals': meals.map((meal) {
          return {
            'name': meal['name'],
            'price': meal['price'] as double,
            'image': meal['image'],
            'quantity': service.meal == meal['name'] ? 1 : 0, // Thay mealPackage thành meal
          };
        }).toList(),
      };
    }).toList();
    notifyListeners();
  }

  void updateMealQuantity(int passengerIndex, int mealIndex, int quantity) {
    if (quantity < 0) return;

    // Đặt lại số lượng của tất cả các bữa ăn khác về 0 cho hành khách này
    for (int i = 0; i < mealSelections[passengerIndex]['meals'].length; i++) {
      if (i != mealIndex) {
        mealSelections[passengerIndex]['meals'][i]['quantity'] = 0;
      }
    }

    // Cập nhật số lượng cho bữa ăn được chọn
    mealSelections[passengerIndex]['meals'][mealIndex]['quantity'] = quantity;

    // Cập nhật meal và mealCost trong AdditionalServicesViewModel
    final selectedMeal = mealSelections[passengerIndex]['meals'][mealIndex];
    if (quantity > 0) {
      additionalServicesViewModel.updateMeal(
        passengerIndex,
        selectedMeal['name'],
        selectedMeal['price'] * quantity,
      );
    } else {
      additionalServicesViewModel.updateMeal(passengerIndex, null, 0.0);
    }
    notifyListeners();
  }

  double getTotalMealCost() {
    double total = 0.0;
    for (var selection in mealSelections) {
      for (var meal in selection['meals']) {
        total += (meal['quantity'] as int) * (meal['price'] as double);
      }
    }
    return total;
  }

  int getTotalMealCount() {
    int total = 0;
    for (var selection in mealSelections) {
      for (var meal in selection['meals']) {
        total += meal['quantity'] as int;
      }
    }
    return total;
  }

  String getFormattedTotalMealCost() {
    return additionalServicesViewModel.formatCurrency(getTotalMealCost());
  }
}