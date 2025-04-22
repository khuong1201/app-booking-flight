import 'dart:convert';

import 'package:booking_flight/core/constants/app_colors.dart';
import 'package:booking_flight/core/utils/validator_utils.dart';
import 'package:booking_flight/data/contact_info_storage.dart';
import 'package:booking_flight/data/passenger_infor_model.dart';
import 'package:booking_flight/presentation/viewmodel/home/detail_flight_tickets_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassengerInfoViewModel extends ChangeNotifier {
  final int adultCount;
  final int childCount;
  final int infantCount;
  final DetailFlightTicketsViewModel detailViewModel;
  final ContactInfoStorage _storage = ContactInfoStorage();

  String phoneNumber = '';
  String email = '';
  bool saveContactInfo = false;
  late List<Passenger> _passengers;
  List<Passenger> get passengers => _passengers;

  String get flightRoute => detailViewModel.routeTitle;
  String get totalAmount => detailViewModel.totalPrice;
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
    _loadSavedContactInfo();
  }

  void _initPassengers() {
    _passengers = [
      ...List.generate(adultCount, (_) => Passenger(type: 'Adult')),
      ...List.generate(childCount, (_) => Passenger(type: 'Child')),
      ...List.generate(infantCount, (_) => Passenger(type: 'Infant')),
    ];
  }

  String _getContactIdentifier() {
    final identifier = phoneNumber.isNotEmpty ? phoneNumber : email.isNotEmpty ? email : 'default_user';
    return identifier;
  }

  Future<void> _loadSavedContactInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('contact_info_')).toList();

      if (keys.isNotEmpty) {
        for (var key in keys) {
          final jsonString = prefs.getString(key);
          if (jsonString != null) {
            final jsonMap = jsonDecode(jsonString);
            final contactInfo = ContactInfo.fromJson(jsonMap);
            if (contactInfo.phoneNumber != null || contactInfo.email != null) {
              phoneNumber = contactInfo.phoneNumber ?? '';
              email = contactInfo.email ?? '';
              saveContactInfo = true;
              debugPrint('Loaded ContactInfo into ViewModel: $contactInfo');
              notifyListeners();
              return;
            }
          }
        }
      }

      final identifier = _getContactIdentifier();
      if (identifier != 'default_user') {
        final contactInfo = await _storage.loadContactInfo(identifier);
        if (contactInfo != null) {
          phoneNumber = contactInfo.phoneNumber ?? '';
          email = contactInfo.email ?? '';
          saveContactInfo = true;
          debugPrint('Loaded ContactInfo into ViewModel: $contactInfo');
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading saved contact info: $e');
    }
  }

  // New public method to load contact info
  Future<ContactInfo?> loadContactInfo(String identifier) async {
    try {
      return await _storage.loadContactInfo(identifier);
    } catch (e) {
      debugPrint('Error loading contact info for $identifier: $e');
      return null;
    }
  }

  // ... (rest of the existing methods like saveContactInfoIfNeeded, saveTripToFirestore, etc.)
  Future<void> saveContactInfoIfNeeded() async {
    if (saveContactInfo && phoneNumber.isNotEmpty && email.isNotEmpty) {
      try {
        final contactInfo = ContactInfo(
          phoneNumber: phoneNumber,
          email: email,
        );
        final identifier = _getContactIdentifier();
        await _storage.saveContactInfo(contactInfo, identifier);
        debugPrint('Saved ContactInfo via ViewModel: $contactInfo');
        await _storage.debugStoredKeys();
      } catch (e) {
        debugPrint('Error saving contact info: $e');
      }
    }
  }

  Future<void> saveTripToFirestore() async {
    final identifier = _getContactIdentifier();
    try {
      await FirebaseFirestore.instance.collection('trips').doc(identifier).set(toJson());
      debugPrint('Saved trip to Firestore for $identifier');
    } catch (e) {
      debugPrint('Error saving trip to Firestore: $e');
    }
  }

  Future<void> clearSavedContactInfo() async {
    try {
      final identifier = _getContactIdentifier();
      await _storage.clearContactInfo(identifier);
      phoneNumber = '';
      email = '';
      saveContactInfo = false;
      for (var passenger in _passengers) {
        passenger.contactInfo = null;
      }
      debugPrint('Cleared ContactInfo via ViewModel');
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing contact info: $e');
    }
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    return ValidatorUtils.isValidEmail(email) ? null : 'Invalid email format';
  }

  String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return 'Phone number is required';
    return ValidatorUtils.isValidPhone(phone) ? null : 'Invalid phone number';
  }

  void updateContactInfo({String? phoneNumber, String? email}) {
    if (phoneNumber != null) this.phoneNumber = phoneNumber;
    if (email != null) this.email = email;
    notifyListeners();
    // Load saved contact info if the identifier changes
    if (phoneNumber != null || email != null) {
      _loadSavedContactInfo();
    }
  }

  // Rest of the methods (updatePassenger, selectDateOfBirth, etc.) remain unchanged
  void updatePassenger({
    required int index,
    String? lastName,
    String? firstName,
    String? gender,
    DateTime? dateOfBirth,
    String? documentType,
    String? documentNumber,
  }) {
    if (index >= 0 && index < _passengers.length) {
      final passenger = _passengers[index];
      if (lastName != null) passenger.lastName = lastName.isNotEmpty ? lastName : '';
      if (firstName != null) passenger.firstName = firstName.isNotEmpty ? firstName : '';
      if (gender != null) passenger.gender = gender.isNotEmpty ? gender : '';
      if (dateOfBirth != null) {
        if (dateOfBirth.isBefore(DateTime.now()) || dateOfBirth.isAtSameMomentAs(DateTime.now())) {
          passenger.dateOfBirth = dateOfBirth;
          debugPrint('Updated date for passenger $index: $dateOfBirth');
        } else {
          debugPrint('Invalid date: Date in the future for passenger $index');
        }
      }
      if (documentType != null && ['ID Card', 'Passport'].contains(documentType)) {
        passenger.documentType = documentType;
      } else {
        passenger.documentType = 'ID Card';
      }
      if (documentNumber != null && documentNumber.isNotEmpty) {
        if (ValidatorUtils.isValidIdCard(documentNumber, passenger.documentType!)) {
          passenger.documentNumber = documentNumber;
        } else {
          passenger.documentNumber = '';
          debugPrint('Invalid document number for passenger $index: $documentNumber');
        }
      } else {
        passenger.documentNumber = '';
      }
      if (saveContactInfo && phoneNumber.isNotEmpty && email.isNotEmpty) {
        passenger.contactInfo = ContactInfo(phoneNumber: phoneNumber, email: email);
      }
      debugPrint('Updated passenger $index: ${passenger.toString()}');
      notifyListeners();
    } else {
      debugPrint('Invalid passenger index: $index');
    }
  }

  Future<void> selectDateOfBirth({
    required BuildContext context,
    required int passengerIndex,
    required Passenger passenger,
    required TextEditingController dobController,
  }) async {
    final initialDate = passenger.dateOfBirth ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.neutralColor,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(0.9),
            ),
            child: child!,
          ),
        );
      },
    );

    if (pickedDate != null) {
      final isValid = _validateDateForPassengerType(pickedDate, passenger.type);
      if (isValid) {
        final formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        dobController.text = formattedDate;
        updatePassenger(index: passengerIndex, dateOfBirth: pickedDate);
        debugPrint('Formatted DOB for passenger $passengerIndex: $formattedDate');
      } else {
        _showInvalidDateSnackbar(context, passenger.type);
      }
    }
  }

  void _showInvalidDateSnackbar(BuildContext context, String passengerType) {
    final snackBar = SnackBar(
      content: Text('Invalid date of birth for $passengerType'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _validateDateForPassengerType(DateTime date, String type) {
    final now = DateTime.now();
    final age = now.year - date.year;
    final isBeforeBirthday = now.month < date.month || (now.month == date.month && now.day < date.day);

    switch (type) {
      case 'Adult':
        return age > 12 || (age == 12 && !isBeforeBirthday);
      case 'Child':
        return age >= 2 && (age < 12 || (age == 12 && isBeforeBirthday));
      case 'Infant':
        return age < 2 || (age == 2 && isBeforeBirthday);
      default:
        return false;
    }
  }

  String? validatePassenger(Passenger passenger) {
    if (passenger.lastName == null || passenger.lastName!.isEmpty) return 'Last name is required';
    if (passenger.firstName == null || passenger.firstName!.isEmpty) return 'First name is required';
    if (passenger.gender == null || passenger.gender!.isEmpty) return 'Gender is required';
    if (passenger.dateOfBirth == null) return 'Date of birth is required';
    if (passenger.documentNumber == null || passenger.documentNumber!.isEmpty) {
      return 'Document number is required';
    }
    if (!ValidatorUtils.isValidIdCard(passenger.documentNumber!, passenger.documentType!)) {
      return 'Invalid ${passenger.documentType} number';
    }
    return null;
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
              'Doc Num: ${p.documentNumber}, Contact: ${p.contactInfo}');
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

  String getFullName(int index) {
    final passenger = _passengers[index];
    final fullName = '${passenger.lastName ?? ''} ${passenger.firstName ?? ''}'.trim();
    return fullName.isEmpty ? 'Passenger ${index + 1}' : fullName;
  }

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
      updatePassenger(index: index, lastName: value ?? '');
  void onFirstNameChanged(int index, String? value) =>
      updatePassenger(index: index, firstName: value ?? '');
  void onGenderChanged(int index, String? value) =>
      updatePassenger(index: index, gender: value ?? '');
  void onDateOfBirthChanged(int index, DateTime? value) =>
      updatePassenger(index: index, dateOfBirth: value);
  void onDocumentTypeChanged(int index, String? value) =>
      updatePassenger(index: index, documentType: value ?? 'ID Card');
  void onDocumentNumberChanged(int index, String? value) =>
      updatePassenger(index: index, documentNumber: value ?? '');

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
          'documentType': passenger.documentType ?? 'ID Card',
          'documentNumber': passenger.documentNumber ?? 'null',
          'contactInfo': passenger.contactInfo?.toJson(),
        };
      }).toList(),
      'flightDetails': {
        'routeTitle': detailViewModel.routeTitle,
        'totalAmount': detailViewModel.totalPrice,
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