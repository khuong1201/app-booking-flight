import 'package:flutter/material.dart';
import 'package:booking_flight/data/flight_discount_data.dart';

class FlightDiscountViewModel extends ChangeNotifier {
  bool isOneTrip = true;

  List<Map<String, String>> get filteredFlights {
    return flights
        .where((flight) => isOneTrip
        ? flight["type"] == "one-way"
        : flight["type"] == "round-trip")
        .toList();
  }

  void toggleTripType(bool value) {
    isOneTrip = value;
    notifyListeners();
  }
}
