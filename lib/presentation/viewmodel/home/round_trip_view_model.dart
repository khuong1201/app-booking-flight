import 'package:booking_flight/presentation/viewmodel/search_viewmodel/search_flight_tiket_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../view/search_view/search_date_view.dart';
import '../../view/search_view/search_flight_tiket_view.dart';
import '../../view/search_view/search_number_of_passenger_view.dart';
import '../../view/search_view/search_place_view.dart';
import '../../view/search_view/search_seat_view.dart';
import '../../../data/SearchViewModel.dart';

class RoundTripFormViewModel extends ChangeNotifier implements SearchViewModel {
  Map<String, String>? _departureAirport;
  Map<String, String>? _arrivalAirport;
  DateTime? _departureDate;
  DateTime? _returnDate;
  int _passengerAdults = 1;
  int _passengerChilds = 0;
  int _passengerInfants = 0;
  String _seatClass = "Economy";

  @override
  Map<String, dynamic>? get departureAirport => _departureAirport;
  @override
  Map<String, dynamic>? get arrivalAirport => _arrivalAirport;
  @override
  DateTime? get departureDate => _departureDate;
  @override
  DateTime? get returnDate => _returnDate;
  @override
  int get passengerAdults => _passengerAdults;
  @override
  int get passengerChilds => _passengerChilds;
  @override
  int get passengerInfants => _passengerInfants;

  @override
  String get seatClass => _seatClass;

  // ------------------ Update Methods ------------------

  void updateDepartureDate(DateTime selectedDate) {
    if (_departureDate != selectedDate) {
      _departureDate = selectedDate;
      notifyListeners();
    }
  }

  void updateReturnDate(DateTime selectedDate) {
    if (_returnDate != selectedDate) {
      _returnDate = selectedDate;
      notifyListeners();
    }
  }

  void updateLocation(bool isDeparture, Map<String, String> selectedAirport) {
    if (isDeparture) {
      _departureAirport = selectedAirport;
    } else {
      _arrivalAirport = selectedAirport;
    }
    notifyListeners();
  }

  void updatePassengerCount({
    required int adults,
    required int childs,
    required int infants,
  }) {
    _passengerAdults = adults.clamp(1, 9);
    _passengerChilds = childs.clamp(0, 9);
    _passengerInfants = infants.clamp(0, 9);
    notifyListeners();
  }

  void updateSeatClass(String selectedClass) {
    if (_seatClass != selectedClass) {
      _seatClass = selectedClass;
      notifyListeners();
    }
  }

  // ------------------ UI Helpers ------------------

  Future<void> selectDate(BuildContext context, bool isDeparture, bool isRoundTrip) async {
    final selectedDate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectionDate(isRoundTrip: true)),
    );

    if (selectedDate is Map<String, DateTime?>) {
      if (selectedDate['departingDate'] != null) {
        updateDepartureDate(selectedDate['departingDate']!);
      }
      if (isRoundTrip && selectedDate['returningDate'] != null) {
        updateReturnDate(selectedDate['returningDate']!);
      }
    }
  }

  Future<void> showLocationPicker(BuildContext context, bool isDeparture) async {
    final selectedAirport = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPlace(
          selectedAirport: isDeparture ? (_arrivalAirport?["code"]) : _departureAirport?["code"],
        ),
      ),
    );

    if (selectedAirport is Map<String, String>) {
      updateLocation(isDeparture, selectedAirport);
      if (_departureAirport?["city"] == _arrivalAirport?["city"]) {
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
                _departureAirport = null;
              } else {
                _arrivalAirport = null;
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
    if (result != null && result.containsKey('adults') && result.containsKey('childs') && result.containsKey('infants')) {
      updatePassengerCount(
        adults: result['adults'],
        childs: result['childs'],
        infants: result['infants'],
      );
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

  // ------------------ Business Logic ------------------

  String totalPassenger() => '${_passengerAdults + _passengerChilds + _passengerInfants}';

  void searchFlights(BuildContext context) {
    if (_departureAirport == null || _arrivalAirport == null) {
      _showErrorDialog(context, "Vui lòng chọn điểm đi và điểm đến.", false);
      return;
    }

    if (_departureDate == null || _returnDate == null) {
      _showErrorDialog(context, "Vui lòng chọn ngày đi và ngày về.", false);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<RoundTripFormViewModel>.value(
              value: this,
            ),
            ChangeNotifierProvider<FlightTicketViewModel>(
              create: (_) => FlightTicketViewModel(searchViewModel: this),
            ),
          ],
          child: FlightTicketScreen(searchViewModel: this),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return {
      'departureAirport': _departureAirport,
      'arrivalAirport': _arrivalAirport,
      'departureDate': _departureDate != null ? dateFormat.format(_departureDate!) : null,
      'returnDate': _returnDate != null ? dateFormat.format(_returnDate!) : null,
      'passengers': {
        'adults': _passengerAdults,
        'childs': _passengerChilds,
        'infants': _passengerInfants,
      },
      'seatClass': _seatClass,
    };
  }

  void resetData() {
    _departureAirport = null;
    _arrivalAirport = null;
    _departureDate = null;
    _returnDate = null;
    _passengerAdults = 1;
    _passengerChilds = 0;
    _passengerInfants = 0;
    _seatClass = "Economy";
    notifyListeners();
  }
}