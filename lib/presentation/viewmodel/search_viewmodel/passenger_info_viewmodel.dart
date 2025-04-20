import 'package:booking_flight/core/constants/app_colors.dart';
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

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email) ? null : 'Invalid email format';
  }

  String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return 'Phone number is required';
    final phoneRegex = RegExp(r'^\+?\d{10,15}$');
    return phoneRegex.hasMatch(phone) ? null : 'Invalid phone number';
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
      passenger.documentNumber = documentNumber?.isNotEmpty == true ? documentNumber : '';
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
    // Lấy ngày sinh hiện tại hoặc mặc định là ngày hôm nay
    final initialDate = passenger.dateOfBirth ?? DateTime.now();

    // Hiển thị DatePicker
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
              textScaleFactor: 0.9,
            ),
            child: child!,
          ),
        );
      },
    );

    // Nếu người dùng đã chọn ngày
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

  /// Hiển thị thông báo nếu ngày không hợp lệ
  void _showInvalidDateSnackbar(BuildContext context, String passengerType) {
    final snackBar = SnackBar(
      content: Text(
        'Ngày không hợp lệ cho hành khách loại $passengerType. Vui lòng chọn lại.',
      ),
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