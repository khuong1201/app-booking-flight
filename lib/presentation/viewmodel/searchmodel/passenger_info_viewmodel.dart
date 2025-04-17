import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:booking_flight/data/search_tickets_tmp_data.dart';
import 'package:booking_flight/data/passenger_infor_model.dart';
import 'package:booking_flight/data/search_flight_Data.dart';

class PassengerInfoViewModel extends ChangeNotifier {
  final int adultCount;
  final int childCount;
  final int infantCount;

  String phoneNumber = '';
  String email = '';
  bool saveContactInfo = false;
  late List<Passenger> _passengers;
  List<Passenger> get passengers => _passengers;

  PassengerInfoViewModel({
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
  }) {
    _initPassengers();
  }

  void _initPassengers() {
    _passengers = [
      ...List.generate(adultCount, (_) => Passenger(type: 'Adult')),
      ...List.generate(childCount, (_) => Passenger(type: 'Child')),
      ...List.generate(infantCount, (_) => Passenger(type: 'Infant')),
    ];
  }

  void updateContactInfo({String? phoneNumber, String? email}) {
    if (phoneNumber != null) this.phoneNumber = phoneNumber;
    if (email != null) this.email = email;
    notifyListeners();
  }

  void updatePassenger({
    required int index,
    String? lastName,
    String? firstName,
    String? gender,
    DateTime? dateOfBirth,
    String? dateOfBirthRaw,
    String? documentType,
    String? documentNumber,
  }) {
    if (index >= 0 && index < _passengers.length) {
      final passenger = _passengers[index];
      if (lastName != null) passenger.lastName = lastName;
      if (firstName != null) passenger.firstName = firstName;
      if (gender != null) passenger.gender = gender;
      if (dateOfBirth != null) passenger.dateOfBirth = dateOfBirth;
      if (dateOfBirthRaw != null && dateOfBirthRaw.isNotEmpty) {
        try {
          passenger.dateOfBirth = DateFormat('dd/MM/yyyy').parse(dateOfBirthRaw);
        } catch (e) {
          debugPrint('Invalid date format: $e');
        }
      }
      if (documentType != null) passenger.documentType = documentType;
      if (documentNumber != null) passenger.documentNumber = documentNumber;
      notifyListeners();
    }
  }

  void toggleSaveContactInfo(bool value) {
    saveContactInfo = value;
    notifyListeners();
  }

  void logInfo() {
    for (var p in _passengers) {
      debugPrint('${p.type}:${p.lastName} ${p.firstName}, '
          'Gender: ${p.gender}, DOB: ${p.dateOfBirth}, '
          'Doc Type: ${p.documentType}, Doc Num: ${p.documentNumber}');
    }
    debugPrint('Contact Info - Phone: $phoneNumber, Email: $email, Save Contact: $saveContactInfo');
  }

  // Getter cho view
  String? getLastName(int index) => _passengers[index].lastName;
  String? getFirstName(int index) => _passengers[index].firstName;
  String? getGender(int index) => _passengers[index].gender;
  DateTime? getDateOfBirth(int index) => _passengers[index].dateOfBirth;
  String? getDocumentType(int index) => _passengers[index].documentType;
  String? getDocumentNumber(int index) => _passengers[index].documentNumber;

  // Input handler
  void onLastNameChanged(int index, String? value) => updatePassenger(index: index, lastName: value);
  void onFirstNameChanged(int index, String? value) => updatePassenger(index: index, firstName: value);
  void onGenderChanged(int index, String? value) => updatePassenger(index: index, gender: value);
  void onDateOfBirthChanged(int index, DateTime? value) => updatePassenger(index: index, dateOfBirth: value);
  void onDateOfBirthRawChanged(int index, String? value) => updatePassenger(index: index, dateOfBirthRaw: value);
  void onDocumentTypeChanged(int index, String? value) => updatePassenger(index: index, documentType: value);
  void onDocumentNumberChanged(int index, String? value) => updatePassenger(index: index, documentNumber: value);

  List<Passenger> get allPassengers => _passengers;
}
