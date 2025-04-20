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
  int? selectedPassenger;

  OrderMealViewModel({
    required this.flightData,
    required this.passengerInfoViewModel,
    required this.additionalServicesViewModel,
  }) {
    _initMealSelections();
  }

  void _initMealSelections() {
    if (passengerInfoViewModel.passengers.isEmpty || meals.isEmpty) {
      mealSelections = [];
      selectedPassenger = null;
      notifyListeners();
      return;
    }

    mealSelections = List.generate(passengerInfoViewModel.passengers.length, (passengerIndex) {
      final service = passengerIndex < additionalServicesViewModel.additionalServices.length
          ? additionalServicesViewModel.additionalServices[passengerIndex]
          : null;
      return {
        'passengerIndex': passengerIndex,
        'passengerName': passengerInfoViewModel.getFullName(passengerIndex),
        'meals': meals.map((meal) {
          return {
            'name': meal['name'] as String,
            'price': (meal['price'] as num).toDouble(),
            'image': meal['image'] as String,
            'quantity': service?.meal == meal['name'] ? 1 : 0,
          };
        }).toList(),
      };
    });
    selectedPassenger = 0; // Chọn hành khách đầu tiên mặc định
    notifyListeners();
  }

  void togglePassengerSelection(int passengerIndex) {
    selectedPassenger = passengerIndex;
    notifyListeners();
  }

  void updateMealQuantity(int mealIndex, int quantity) {
    if (selectedPassenger == null ||
        mealIndex < 0 ||
        mealIndex >= mealSelections[selectedPassenger!]['meals'].length ||
        quantity < 0) {
      return;
    }

    // Cập nhật số lượng cho món ăn được chọn
    mealSelections[selectedPassenger!]['meals'][mealIndex]['quantity'] = quantity;

    // Cập nhật additionalServicesViewModel
    final selectedMeal = mealSelections[selectedPassenger!]['meals'][mealIndex];
    if (quantity > 0) {
      final mealPrice = (selectedMeal['price'] as double) * quantity;
      additionalServicesViewModel.updateMeal(
        selectedPassenger!,
        selectedMeal['name'] as String,
        mealPrice,
        quantity,
      );
    } else {
      additionalServicesViewModel.updateMeal(selectedPassenger!, null, 0.0, 0);
    }
    notifyListeners();
  }
  double getTotalMealCost() {
    double total = 0.0;
    for (var selection in mealSelections) {
      final meals = selection['meals'] as List<Map<String, dynamic>>;
      for (var meal in meals) {
        total += (meal['quantity'] as int) * (meal['price'] as double);
      }
    }
    return total;
  }

  int getTotalMealCount() {
    int total = 0;
    for (var selection in mealSelections) {
      final meals = selection['meals'] as List<Map<String, dynamic>>;
      for (var meal in meals) {
        total += (meal['quantity'] as num?)?.toInt() ?? 0; // Xử lý null
      }
    }
    return total;
  }

  int getTotalMealCountForPassenger(int passengerIndex) {
    if (passengerIndex < 0 || passengerIndex >= mealSelections.length) return 0;
    final meals = mealSelections[passengerIndex]['meals'] as List<Map<String, dynamic>>;
    return meals.fold(0, (sum, meal) => sum + ((meal['quantity'] as num?)?.toInt() ?? 0));
  }

  String getFormattedTotalMealCost() {
    return additionalServicesViewModel.formatCurrency(getTotalMealCost());
  }

  String getFormattedTotalMealCostForPassenger(int passengerIndex) {
    if (passengerIndex < 0 || passengerIndex >= mealSelections.length) {
      return additionalServicesViewModel.formatCurrency(0.0);
    }
    final selection = mealSelections[passengerIndex];
    final meals = selection['meals'] as List<Map<String, dynamic>>;
    final total = meals.fold<double>(
      0.0,
          (sum, meal) => sum + (meal['quantity'] as int) * (meal['price'] as double),
    );
    return additionalServicesViewModel.formatCurrency(total);
  }

}