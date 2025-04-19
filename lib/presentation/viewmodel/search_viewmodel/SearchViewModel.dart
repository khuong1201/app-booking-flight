import 'package:flutter/material.dart';

abstract class SearchViewModel {
  Map<String, dynamic>? get departureAirport;
  Map<String, dynamic>? get arrivalAirport;
  DateTime? get departureDate;
  DateTime? get returnDate;
  int get passengerAdults;
  int get passengerChilds;
  int get passengerInfants;
  String get seatClass;
}

class OneWayTripViewModel extends ChangeNotifier implements SearchViewModel {
  @override
  Map<String, dynamic>? departureAirport;
  @override
  Map<String, dynamic>? arrivalAirport;
  @override
  DateTime? departureDate;
  @override
  DateTime? get returnDate => null;
  @override
  int passengerAdults = 0;
  @override
  int passengerChilds = 0;
  @override
  int passengerInfants = 0;
  @override
  String get seatClass => "Economy";
}

class RoundTripFormViewModel extends ChangeNotifier implements SearchViewModel {
  @override
  Map<String, dynamic>? departureAirport;
  @override
  Map<String, dynamic>? arrivalAirport;
  @override
  DateTime? departureDate;
  @override
  DateTime? returnDate;
  @override
  int passengerAdults = 0;
  @override
  int passengerChilds = 0;
  @override
  int passengerInfants = 0;
  @override
  String get seatClass => "Economy";
}