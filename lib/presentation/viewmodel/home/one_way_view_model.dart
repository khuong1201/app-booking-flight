import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/search_tickets_tmp_data.dart';
import '../../view/search/search_date_view.dart';
import '../../view/search/search_flight_tiket_view.dart';
import '../../view/search/search_number_of_passenger_view.dart';
import '../../view/search/search_place_view.dart';
import '../../view/search/search_seat_view.dart';

class OneWayTripViewModel extends ChangeNotifier {
  Map<String, String>? departureAirport;
  Map<String, String>? arrivalAirport;
  DateTime? departureDate;

  int passengerAdults = 1;
  int passengerChilds = 0;
  int passengerInfant = 0;

  String seatClass = "Economy";

  OneWayTripViewModel() {
    _loadTempData();
  }

  Future<void> _loadTempData() async {
    final prefs = await SharedPreferences.getInstance();

    departureAirport = await _loadAirportData(prefs, 'departure');
    arrivalAirport = await _loadAirportData(prefs, 'arrival');
    departureDate = await _loadDateData(prefs);
    passengerAdults = prefs.getInt('one_way_passenger_adults') ?? 1;
    passengerChilds = prefs.getInt('one_way_passenger_childs') ?? 0;
    passengerInfant = prefs.getInt('one_way_passenger_infant') ?? 0;
    seatClass = prefs.getString('one_way_seat_class') ?? "Economy";

    notifyListeners();
  }

  Future<Map<String, String>?> _loadAirportData(SharedPreferences prefs, String prefix) async {
    final code = prefs.getString('one_way_${prefix}_code');
    final city = prefs.getString('one_way_${prefix}_city');
    if (code != null && city != null) {
      return {'code': code, 'city': city};
    }
    return null;
  }

  Future<DateTime?> _loadDateData(SharedPreferences prefs) async {
    final dateStr = prefs.getString('one_way_departure_date');
    if (dateStr != null) {
      return DateTime.tryParse(dateStr);
    }
    return null;
  }

  Future<void> _saveTempData() async {
    final prefs = await SharedPreferences.getInstance();

    if (departureAirport != null) {
      await prefs.setString('one_way_departure_code', departureAirport!['code']!);
      await prefs.setString('one_way_departure_city', departureAirport!['city']!);
    }
    if (arrivalAirport != null) {
      await prefs.setString('one_way_arrival_code', arrivalAirport!['code']!);
      await prefs.setString('one_way_arrival_city', arrivalAirport!['city']!);
    }
    if (departureDate != null) {
      await prefs.setString('one_way_departure_date', departureDate!.toIso8601String());
    }

    await prefs.setInt('one_way_passenger_adults', passengerAdults);
    await prefs.setInt('one_way_passenger_childs', passengerChilds);
    await prefs.setInt('one_way_passenger_infant', passengerInfant);
    await prefs.setString('one_way_seat_class', seatClass);
  }

  void updateDepartureDate(DateTime selectedDate) {
    if (departureDate != selectedDate) {
      departureDate = selectedDate;
      _saveTempData();
      notifyListeners();
    }
  }

  void updateLocation(bool isDeparture, Map<String, String> selectedAirport) {
    if (isDeparture) {
      departureAirport = selectedAirport;
    } else {
      arrivalAirport = selectedAirport;
    }
    _saveTempData();
    notifyListeners();
  }

  void updatePassengerCount({required int adults, required int childs, required int infants}) {
    passengerAdults = adults;
    passengerChilds = childs;
    passengerInfant = infants;
    _saveTempData();
    notifyListeners();
  }

  void updateSeatClass(String selectedClass) {
    if (seatClass != selectedClass) {
      seatClass = selectedClass;
      _saveTempData();
      notifyListeners();
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final selectedDate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectionDate(isRoundTrip: false),
      ),
    );

    if (selectedDate is Map<String, DateTime?> && selectedDate['departingDate'] != null) {
      updateDepartureDate(selectedDate['departingDate']!);
    }
  }

  Future<void> showLocationPicker(BuildContext context, bool isDeparture) async {
    final selectedAirport = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPlace(
          selectedAirport: isDeparture ? (arrivalAirport?["code"]) : departureAirport?["code"],
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

  SearchTicketsTemp createSearchTicketsTemp() {
    String? formattedDepartureDate = departureDate != null
        ? DateFormat('yyyy-MM-dd').format(departureDate!)
        : null;

    // Create the SearchTicketsTemp object
    SearchTicketsTemp searchTicketsTemp = SearchTicketsTemp(
      departingDate: formattedDepartureDate,
      returningDate: null,
      passengerAdults: passengerAdults,
      passengerChilds: passengerChilds,
      passengerInfant: passengerInfant,
      departureAirportCode: departureAirport?['code'],
      arrivalAirportCode: arrivalAirport?['code'],
      seatClass: seatClass,
      isRoundTrip: false,
    );

    // Log the data for debugging
    print('SearchTicketsTemp created:');
    print('Departing Date: ${searchTicketsTemp.departingDate}');
    print('Returning Date: ${searchTicketsTemp.returningDate}');
    print('Passenger Adults: ${searchTicketsTemp.passengerAdults}');
    print('Passenger Childs: ${searchTicketsTemp.passengerChilds}');
    print('Passenger Infants: ${searchTicketsTemp.passengerInfant}');
    print('Departure Airport Code: ${searchTicketsTemp.departureAirportCode}');
    print('Arrival Airport Code: ${searchTicketsTemp.arrivalAirportCode}');
    print('Seat Class: ${searchTicketsTemp.seatClass}');
    print('Is Round Trip: ${searchTicketsTemp.isRoundTrip}');

    return searchTicketsTemp;
  }


  void searchFlights(BuildContext context) {
    if (departureAirport == null || arrivalAirport == null) {
      _showErrorDialog(context, "Vui lòng chọn điểm đi và điểm đến.", false);
      return;
    }

    if (departureDate == null) {
      _showErrorDialog(context, "Vui lòng chọn ngày đi.", false);
      return;
    }

    final searchData = createSearchTicketsTemp();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightTicketScreen(
          departureAirport: "${departureAirport?['city']} (${departureAirport?['code']})",
          arrivalAirport: "${arrivalAirport?['city']} (${arrivalAirport?['code']})",
          departureDate: departureDate!.toLocal().toString().split(' ')[0],
          returnDate: '',
          passengers: passengerAdults + passengerChilds + passengerInfant,
          seatClass: seatClass,
        ),
      ),
    );
  }

  Future<void> clearTempData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('one_way_departure_code');
    await prefs.remove('one_way_departure_city');
    await prefs.remove('one_way_arrival_code');
    await prefs.remove('one_way_arrival_city');
    await prefs.remove('one_way_departure_date');
    await prefs.remove('one_way_passenger_adults');
    await prefs.remove('one_way_passenger_childs');
    await prefs.remove('one_way_passenger_infant');
    await prefs.remove('one_way_seat_class');

    departureAirport = null;
    arrivalAirport = null;
    departureDate = null;
    passengerAdults = 1;
    passengerChilds = 0;
    passengerInfant = 0;
    seatClass = "Economy";

    notifyListeners();
  }
}
