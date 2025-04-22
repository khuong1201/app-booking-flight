import 'package:booking_flight/presentation/view/search_view/search_flight_tiket_view.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/search_flight_tiket_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../view/search_view/search_date_view.dart';
import '../../view/search_view/search_number_of_passenger_view.dart';
import '../../view/search_view/search_place_view.dart';
import '../../view/search_view/search_seat_view.dart';
import '../../../data/SearchViewModel.dart';

class OneWayTripViewModel extends ChangeNotifier implements SearchViewModel {
  Map<String, String>? _departureAirport;
  Map<String, String>? _arrivalAirport;
  DateTime? _departureDate;
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
  DateTime? get returnDate => null;
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
    debugPrint('Updating departure date to: ${selectedDate.toIso8601String()}');
    if (_departureDate != selectedDate) {
      _departureDate = selectedDate;
      notifyListeners();
    } else {
      debugPrint('Departure date unchanged: ${selectedDate.toIso8601String()}');
    }
  }

  void updateLocation(bool isDeparture, Map<String, String> selectedAirport) {
    debugPrint('Updating ${isDeparture ? "departure" : "arrival"} airport: $selectedAirport');
    if (selectedAirport['code'] == null || selectedAirport['city'] == null) {
      debugPrint('Error: Invalid airport data: $selectedAirport');
      return;
    }
    if (isDeparture) {
      _departureAirport = selectedAirport;
    } else {
      _arrivalAirport = selectedAirport;
    }
    notifyListeners();
    debugPrint('${isDeparture ? "Departure" : "Arrival"} airport updated: $selectedAirport');

    if (_departureAirport != null &&
        _arrivalAirport != null &&
        _departureAirport?["city"] == _arrivalAirport?["city"]) {
      debugPrint('Error: Same city for departure and arrival: ${_departureAirport?["city"]}');
    }
  }

  void updatePassengerCount({
    required int adults,
    required int childs,
    required int infants,
  }) {
    debugPrint('Updating passengers: adults=$adults, childs=$childs, infants=$infants');
    if (adults < 1 || childs < 0 || infants < 0) {
      debugPrint('Error: Invalid passenger counts: adults=$adults, childs=$childs, infants=$infants');
      return;
    }
    _passengerAdults = adults.clamp(1, 9);
    _passengerChilds = childs.clamp(0, 9);
    _passengerInfants = infants.clamp(0, 9);
    notifyListeners();
    debugPrint('Passengers updated: adults=$_passengerAdults, childs=$_passengerChilds, infants=$_passengerInfants');
  }

  void updateSeatClass(String selectedClass) {
    debugPrint('Updating seat class to: $selectedClass');
    if (selectedClass.isEmpty) {
      debugPrint('Error: Empty seat class');
      return;
    }
    if (_seatClass != selectedClass) {
      _seatClass = selectedClass;
      notifyListeners();
      debugPrint('Seat class updated: $_seatClass');
    } else {
      debugPrint('Seat class unchanged: $selectedClass');
    }
  }

  // ------------------ UI Helpers ------------------

  Future<void> selectDate(BuildContext context) async {
    debugPrint('Opening date picker');
    final result = await Navigator.push<Map<String, DateTime?>>(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectionDate(isRoundTrip: false),
      ),
    );

    if (result?['departingDate'] != null) {
      updateDepartureDate(result!['departingDate']!);
    } else {
      debugPrint('Date picker closed with no selection');
    }
  }

  Future<void> showLocationPicker(BuildContext context, bool isDeparture) async {
    debugPrint('Opening location picker for ${isDeparture ? "departure" : "arrival"}');
    final selected = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPlace(
          selectedAirport: isDeparture ? (_arrivalAirport?["code"]) : _departureAirport?["code"],
        ),
      ),
    );

    if (selected != null) {
      updateLocation(isDeparture, selected);

      if (_departureAirport?["city"] == _arrivalAirport?["city"]) {
        _showErrorDialog(context, "Điểm đi và điểm đến không thể giống nhau. Vui lòng chọn lại.", isDeparture);
      }
    } else {
      debugPrint('Location picker closed with no selection');
    }
  }

  Future<void> showPassengerPicker(BuildContext context) async {
    debugPrint('Opening passenger picker');
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => const PassengerSelectionSheet(),
    );

    if (result != null) {
      updatePassengerCount(
        adults: result['adults'],
        childs: result['childs'],
        infants: result['infants'],
      );
    } else {
      debugPrint('Passenger picker closed with no selection');
    }
  }

  Future<void> showSeatPicker(BuildContext context) async {
    debugPrint('Opening seat picker');
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SeatSelectionSheet(),
    );

    if (selected != null) {
      updateSeatClass(selected);
    } else {
      debugPrint('Seat picker closed with no selection');
    }
  }

  void _showErrorDialog(BuildContext context, String message, bool isDeparture) {
    debugPrint('Showing error dialog: $message');
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
              debugPrint('Reset ${isDeparture ? "departure" : "arrival"} airport due to error');
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ------------------ Business Logic ------------------

  String totalPassenger() {
    final total = _passengerAdults + _passengerChilds + _passengerInfants;
    debugPrint('Calculating total passengers: $total');
    return '$total';
  }

  void searchFlights(BuildContext context) {
    debugPrint('Initiating flight search');
    debugPrint('Current state: departureAirport=$_departureAirport, arrivalAirport=$_arrivalAirport, departureDate=$_departureDate, seatClass=$_seatClass, passengers={adults: $_passengerAdults, childs: $_passengerChilds, infants: $_passengerInfants}');

    if (_departureAirport == null || _arrivalAirport == null) {
      debugPrint('Error: Missing departure or arrival airport');
      _showErrorDialog(context, "Vui lòng chọn điểm đi và điểm đến.", false);
      return;
    }

    if (_departureDate == null) {
      debugPrint('Error: Missing departure date');
      _showErrorDialog(context, "Vui lòng chọn ngày đi.", false);
      return;
    }

    debugPrint('Navigating to FlightTicketScreen with valid inputs');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<OneWayTripViewModel>.value(
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
    final json = {
      'departureAirport': _departureAirport,
      'arrivalAirport': _arrivalAirport,
      'departureDate': _departureDate != null ? dateFormat.format(_departureDate!) : null,
      'passengers': {
        'adults': _passengerAdults,
        'childs': _passengerChilds,
        'infants': _passengerInfants,
      },
      'seatClass': _seatClass,
    };
    debugPrint('Serializing to JSON: $json');
    return json;
  }

  void resetData() {
    debugPrint('Resetting OneWayTripViewModel data');
    _departureAirport = null;
    _arrivalAirport = null;
    _departureDate = null;
    _passengerAdults = 1;
    _passengerChilds = 0;
    _passengerInfants = 0;
    _seatClass = "Economy";
    notifyListeners();
    debugPrint('Data reset complete');
  }
}