import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/passenger_infor_model.dart';
import '../home/Detail_flight_tickets_view_model.dart';

class PassengerInfoViewModel extends ChangeNotifier {
  final int adultCount;
  final int childCount;
  final int infantCount;
  final DetailFlightTicketsViewModel detailViewModel;

  String phoneNumber = '';
  String email = '';
  bool saveContactInfo = false;
  late List<Passenger> _passengers;
  List<Passenger> get passengers => _passengers;

  // Access flight details from DetailFlightTicketsViewModel
  String get flightRoute => detailViewModel.routeTitle;
  String get totalAmount => detailViewModel.totalAmountString;
  String get flightCode => detailViewModel.flightCode;
  String get departureAirport => detailViewModel.departureAirport;
  String get arrivalAirport => detailViewModel.arrivalAirport;

  PassengerInfoViewModel({
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.detailViewModel,
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
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void updateContactInfo({String? phoneNumber, String? email}) {
    if (phoneNumber != null) this.phoneNumber = phoneNumber;
    if (email != null) {
      if (isValidEmail(email)) {
        this.email = email;
      } else {
        debugPrint('Invalid email format');
        // Có thể thông báo lỗi cho UI
      }
    }
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
      debugPrint(
          '${p.type}: ${p.lastName} ${p.firstName}, Gender: ${p.gender}, '
              'DOB: ${p.dateOfBirth}, Doc Type: ${p.documentType}, '
              'Doc Num: ${p.documentNumber}');
    }
    debugPrint(
        'Contact Info - Phone: $phoneNumber, Email: $email, Save Contact: $saveContactInfo');
  }

  String? getLastName(int index) => _passengers[index].lastName;
  String? getFirstName(int index) => _passengers[index].firstName;
  String? getGender(int index) => _passengers[index].gender;
  DateTime? getDateOfBirth(int index) => _passengers[index].dateOfBirth;
  String? getDocumentType(int index) => _passengers[index].documentType;
  String? getDocumentNumber(int index) => _passengers[index].documentNumber;

  // Thêm phương thức để lấy tên đầy đủ
  String getFullName(int index) {
    final passenger = _passengers[index];
    final fullName = '${passenger.lastName ?? ''} ${passenger.firstName ?? ''}'.trim();
    return fullName.isEmpty ? 'Passenger ${index + 1}' : fullName;
  }

  // Thêm phương thức để lấy tuổi
  int getAge(int index) {
    final passenger = _passengers[index];
    final dob = passenger.dateOfBirth;
    if (dob == null) return 0;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  void onLastNameChanged(int index, String? value) =>
      updatePassenger(index: index, lastName: value);
  void onFirstNameChanged(int index, String? value) =>
      updatePassenger(index: index, firstName: value);
  void onGenderChanged(int index, String? value) =>
      updatePassenger(index: index, gender: value);
  void onDateOfBirthChanged(int index, DateTime? value) =>
      updatePassenger(index: index, dateOfBirth: value);
  void onDateOfBirthRawChanged(int index, String? value) =>
      updatePassenger(index: index, dateOfBirthRaw: value);
  void onDocumentTypeChanged(int index, String? value) =>
      updatePassenger(index: index, documentType: value);
  void onDocumentNumberChanged(int index, String? value) =>
      updatePassenger(index: index, documentNumber: value);

  List<Passenger> get allPassengers => _passengers;

  Map<String, dynamic> toJson() {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return {
      'contactInfo': {
        'phoneNumber': phoneNumber,
        'email': email,
        'saveContactInfo': saveContactInfo,
      },
      'passengers': _passengers.map((passenger) {
        return {
          'type': passenger.type,
          'lastName': passenger.lastName,
          'firstName': passenger.firstName,
          'gender': passenger.gender,
          'dateOfBirth': passenger.dateOfBirth != null
              ? dateFormat.format(passenger.dateOfBirth!)
              : null,
          'documentType': passenger.documentType,
          'documentNumber': passenger.documentNumber,
        };
      }).toList(),
      'flightDetails': {
        'routeTitle': detailViewModel.routeTitle,
        'totalAmount': detailViewModel.totalAmountString,
        'flightCode': detailViewModel.flightCode,
        'departureAirport': detailViewModel.departureAirport,
        'arrivalAirport': detailViewModel.arrivalAirport,
        'departureTime': detailViewModel.departureTime,
        'arrivalTime': detailViewModel.arrivalTime,
        'flightDuration': detailViewModel.flightDuration,
        'flightType': detailViewModel.flightType,
      },
    };
  }
}