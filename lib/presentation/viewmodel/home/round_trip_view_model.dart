import 'package:flutter/material.dart';
import '../../view/search/search_date.dart';
import '../../view/search/search_number_of_passenger.dart';
import '../../view/search/search_place.dart';
import '../../view/search/search_seat.dart';

class RoundTripFormViewModel extends ChangeNotifier {
  Map<String, String>? departureAirport;
  Map<String, String>? arrivalAirport;
  DateTime? departureDate;
  DateTime? returnDate;
  int passengers = 1;
  String seatClass = "economy";
  String get currentSeatClass => seatClass;
  void updateDepartureDate(DateTime selectedDate) {
    if (departureDate != selectedDate) {
      departureDate = selectedDate;
      notifyListeners();
    }
  }

  void updateReturnDate(DateTime selectedDate) {
    if (returnDate != selectedDate) {
      returnDate = selectedDate;
      notifyListeners();
    }
  }

  void updateLocation(bool isDeparture, Map<String, String> selectedAirport) {
    if (isDeparture) {
      departureAirport = selectedAirport;
    } else {
      arrivalAirport = selectedAirport;
    }
    notifyListeners();
  }

  void updatePassengerCount(int totalPassengers) {
    if (passengers != totalPassengers) {
      passengers = totalPassengers;
      notifyListeners();
    }
  }

  void updateSeatClass(String selectedClass) {
    if (seatClass != selectedClass) {
      seatClass = selectedClass;
      notifyListeners();
    }
  }

  Future<void> selectDate(BuildContext context, bool isDeparture, bool isRoundTrip) async {
    final selectedDate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectionDate()),
    );

    if (selectedDate is Map<String, DateTime?>) {
      updateDepartureDate(selectedDate['departingDate'] ?? departureDate!);
      if (isRoundTrip) {
        updateReturnDate(selectedDate['returningDate'] ?? returnDate!);
      }
    }
  }

  Future<void> showLocationPicker(BuildContext context, bool isDeparture) async {
    final selectedAirport = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPlace(
          selectedAirport: isDeparture ? (arrivalAirport?["code"]) : (departureAirport?["code"]),
        ),
      ),
    );

    if (selectedAirport is Map<String, String>) {
      updateLocation(isDeparture, selectedAirport);
      if (departureAirport?["city"] == arrivalAirport?["city"]) {
        _showErrorDialog(context, "Điểm đi và điểm đến không thể giống nhau. Vui lòng chọn lại.", isDeparture);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message, bool isDeparture) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (isDeparture) {
                departureAirport = null;
              } else {
                arrivalAirport = null;
              }
              notifyListeners();
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> showPassengerPicker(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => const PassengerSelectionSheet(),
    );
    if (result != null && result.containsKey('totalPassengers')) {
      updatePassengerCount(result['totalPassengers']);
    }
  }

  Future<void> showSeatPicker(BuildContext context) async {
    final selectedClass = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SeatSelectionSheet(),
    );

    if (selectedClass != null) {
      updateSeatClass(selectedClass);
    }
  }

  void searchFlights(BuildContext context) {
    if (departureAirport == null || arrivalAirport == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Lỗi"),
          content: const Text("Vui lòng chọn cả điểm đi và điểm đến."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
    }
  }
}