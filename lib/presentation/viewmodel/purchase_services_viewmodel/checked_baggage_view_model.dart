import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/additional_services_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:flutter/material.dart';

class CheckedBaggageViewModel extends ChangeNotifier {
  final FlightData? flightData;
  final PassengerInfoViewModel passengerInfoViewModel;
  final AdditionalServicesViewModel additionalServicesViewModel;
  double _totalBaggageCost = 0;

  CheckedBaggageViewModel({
    this.flightData,
    required this.passengerInfoViewModel,
    required this.additionalServicesViewModel,
  }) {
    _updateTotalBaggageCost();
  }

  double get totalBaggageCost => _totalBaggageCost;
  String get formattedTotalBaggageCost => formatCurrency(_totalBaggageCost);

  void selectBaggage(int passengerIndex, String? baggage, double cost) {
    // Cập nhật gói hành lý trong AdditionalServicesViewModel
    additionalServicesViewModel.updateBaggage(passengerIndex, baggage, cost);

    // Cập nhật tổng chi phí hành lý
    _updateTotalBaggageCost();

    notifyListeners();
  }

  void _updateTotalBaggageCost() {
    _totalBaggageCost = additionalServicesViewModel.additionalServices.fold(
      0.0,
          (sum, service) => sum + service.baggageCost,
    );
  }

  String formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0);
    return formatted.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}