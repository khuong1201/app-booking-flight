import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/additional_services_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:flutter/material.dart';

class SeatSelectionViewModel extends ChangeNotifier {
  final FlightData? flightData;
  final PassengerInfoViewModel passengerInfoViewModel;
  final AdditionalServicesViewModel additionalServicesViewModel;
  double _totalSeatCost = 0;
  int? _selectedPassenger;

  final List<List<bool>> _seatAvailability = List.generate(
    40,
        (row) => List.generate(6, (col) {
      if ((col == 0 || col == 5) && (row == 10 || row == 25)) {
        return false;
      }
      if ((row + col) % 7 == 0) {
        return false;
      }
      return true;
    }),
  );

  static const double _specialSeatCost = 97200;
  static const double _frontSeatCost = 43200;
  static const double _emergencySeatCost = 97200;
  static const double _regularSeatCost = 32400;

  SeatSelectionViewModel({
    this.flightData,
    required this.passengerInfoViewModel,
    required this.additionalServicesViewModel,
  }) {
    _updateTotalSeatCost();
  }

  double get totalSeatCost => _totalSeatCost;
  String get formattedTotalSeatCost => formatCurrency(_totalSeatCost);
  int? get selectedPassenger => _selectedPassenger;

  String getSelectedSeatForPassenger(int passengerIndex) {
    if (passengerIndex < 0 || passengerIndex >= additionalServicesViewModel.additionalServices.length) {
      return 'None';
    }
    return additionalServicesViewModel.additionalServices[passengerIndex].seatSelection ?? 'None';
  }

  double getSeatCostForPassenger(int passengerIndex) {
    if (passengerIndex < 0 || passengerIndex >= additionalServicesViewModel.additionalServices.length) {
      return 0.0;
    }
    return additionalServicesViewModel.additionalServices[passengerIndex].seatCost;
  }

  bool isSeatAvailable(int row, int col) {
    if (row < 1 || row > _seatAvailability.length || col < 0 || col >= _seatAvailability[0].length) {
      return false;
    }
    return _seatAvailability[row - 1][col];
  }

  bool isSeatSelected(int row, int col) {
    final seatLabel = _getSeatLabel(row, col);
    return additionalServicesViewModel.additionalServices.any((service) => service.seatSelection == seatLabel);
  }

  bool isSeatSelectedByCurrentPassenger(int row, int col, int passengerIndex) {
    if (passengerIndex < 0 || passengerIndex >= additionalServicesViewModel.additionalServices.length) {
      return false;
    }
    final seatLabel = _getSeatLabel(row, col);
    return additionalServicesViewModel.additionalServices[passengerIndex].seatSelection == seatLabel;
  }

  bool isSeatSelectedByOtherPassenger(int row, int col, int passengerIndex) {
    if (passengerIndex < 0 || passengerIndex >= additionalServicesViewModel.additionalServices.length) {
      return false;
    }
    final seatLabel = _getSeatLabel(row, col);
    for (int i = 0; i < additionalServicesViewModel.additionalServices.length; i++) {
      if (i != passengerIndex && additionalServicesViewModel.additionalServices[i].seatSelection == seatLabel) {
        return true;
      }
    }
    return false;
  }

  void selectSeat(int passengerIndex, String? seat, double cost) {
    if (passengerIndex < 0 || passengerIndex >= additionalServicesViewModel.additionalServices.length) {
      debugPrint('Error: Invalid passengerIndex $passengerIndex');
      return;
    }
    debugPrint('Selecting seat for passenger $passengerIndex: $seat, cost: $cost');
    additionalServicesViewModel.updateSeatSelection(passengerIndex, seat, cost);
    _updateTotalSeatCost();
    notifyListeners();
  }

  void togglePassengerSelection(int passengerIndex) {
    if (passengerIndex < 0 || passengerIndex >= additionalServicesViewModel.additionalServices.length) {
      debugPrint('Error: Invalid passengerIndex $passengerIndex');
      return;
    }
    _selectedPassenger = _selectedPassenger == passengerIndex ? null : passengerIndex;
    notifyListeners();
  }

  void toggleSeatForPassenger(int row, int col, int passengerIndex) {
    if (!isSeatAvailable(row, col)) {
      debugPrint('Seat $row${String.fromCharCode(65 + col)} is not available');
      return;
    }
    if (isSeatSelectedByOtherPassenger(row, col, passengerIndex)) {
      debugPrint('Seat $row${String.fromCharCode(65 + col)} is selected by another passenger');
      return;
    }

    final seatLabel = _getSeatLabel(row, col);
    final cost = _getSeatCost(row, col);
    final currentSeat = additionalServicesViewModel.additionalServices[passengerIndex].seatSelection;

    debugPrint('Toggling seat $seatLabel for passenger $passengerIndex');
    if (currentSeat == seatLabel) {
      selectSeat(passengerIndex, null, 0.0);
    } else {
      selectSeat(passengerIndex, seatLabel, cost);
    }
  }

  void _updateTotalSeatCost() {
    _totalSeatCost = additionalServicesViewModel.additionalServices.fold(
      0.0,
          (sum, service) => sum + (service.seatCost ?? 0.0),
    );
  }

  String formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0);
    return formatted.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
  }

  String _getSeatLabel(int row, int col) {
    const columns = ['A', 'B', 'C', 'D', 'E', 'F'];
    if (col < 0 || col >= columns.length) {
      return '';
    }
    return '$row${columns[col]}';
  }

  double _getSeatCost(int row, int col) {
    if (row >= 1 && row <= 5) {
      return _specialSeatCost;
    } else if (row >= 6 && row <= 26) {
      return _frontSeatCost;
    } else if (row == 11 || row == 27 || (row == 12 && (col == 0 || col == 5))) {
      return _emergencySeatCost;
    } else {
      return _regularSeatCost;
    }
  }

  void confirmSelection(BuildContext context) {
    debugPrint('Confirming seat selection');
    additionalServicesViewModel.notifyListeners();
    notifyListeners();
    Navigator.pop(context);
  }
}