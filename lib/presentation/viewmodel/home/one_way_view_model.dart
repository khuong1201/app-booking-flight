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
  int passengerInfants = 0;

  String seatClass = "Economy";

  Future<void> _loadTempData() async {
    final prefs = await SharedPreferences.getInstance();

    departureAirport = await _loadAirportData(prefs, 'departure');
    arrivalAirport = await _loadAirportData(prefs, 'arrival');
    departureDate = await _loadDateData(prefs);

    passengerAdults = prefs.getInt('one_way_passenger_adults') ?? 1;
    passengerChilds = prefs.getInt('one_way_passenger_childs') ?? 0;
    passengerInfants = prefs.getInt('one_way_passenger_infant') ?? 0;
    seatClass = prefs.getString('one_way_seat_class') ?? "Economy";

    // In giá trị tải từ SharedPreferences
    print("Loaded Passenger Data: Adults: $passengerAdults, Children: $passengerChilds, Infants: $passengerInfants");
    print("Loaded Seat Class: $seatClass");
    print("Loaded Departure Airport: ${departureAirport?['city']}, ${departureAirport?['code']}");
    print("Loaded Arrival Airport: ${arrivalAirport?['city']}, ${arrivalAirport?['code']}");
    print("Loaded Departure Date: $departureDate");

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
    return dateStr != null ? DateTime.tryParse(dateStr) : null;
  }

  Future<void> _saveTempData() async {
    final prefs = await SharedPreferences.getInstance();

    if (departureAirport != null) {
      prefs.setString('one_way_departure_code', departureAirport!['code']!);
      prefs.setString('one_way_departure_city', departureAirport!['city']!);
      print("Saved Departure Airport: ${departureAirport!['code']}, ${departureAirport!['city']}");
    }
    if (arrivalAirport != null) {
      prefs.setString('one_way_arrival_code', arrivalAirport!['code']!);
      prefs.setString('one_way_arrival_city', arrivalAirport!['city']!);
      print("Saved Arrival Airport: ${arrivalAirport!['code']}, ${arrivalAirport!['city']}");
    }
    if (departureDate != null) {
      prefs.setString('one_way_departure_date', departureDate!.toIso8601String());
      print("Saved Departure Date: ${departureDate!.toIso8601String()}");
    }

    prefs.setInt('one_way_passenger_adults', passengerAdults);
    prefs.setInt('one_way_passenger_childs', passengerChilds);
    prefs.setInt('one_way_passenger_infant', passengerInfants);
    print("Saved Passengers: Adults: $passengerAdults, Children: $passengerChilds, Infants: $passengerInfants");

    prefs.setString('one_way_seat_class', seatClass);
    print("Saved Seat Class: $seatClass");
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
    passengerInfants = infants;
    // In ra số lượng hành khách mới để debug
    print("Updated Passenger Count: Adults: $passengerAdults, Children: $passengerChilds, Infants: $passengerInfants");
    _saveTempData();
    print("🟢 Đã lưu SharedPreferences: Adults: $passengerAdults, Children: $passengerChilds, Infants: $passengerInfants");
    notifyListeners();
  }

  // Tổng số hành khách
  String totalPassenger() {
    return '${passengerAdults + passengerChilds + passengerInfants}';
  }

  void updateSeatClass(String selectedClass) {
    if (seatClass != selectedClass) {
      seatClass = selectedClass;
      _saveTempData();
      notifyListeners();
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final selectedDate = await Navigator.push<Map<String, DateTime?>>(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectionDate(isRoundTrip: false),
      ),
    );

    if (selectedDate?['departingDate'] != null) {
      updateDepartureDate(selectedDate!['departingDate']!);
    }
  }

  Future<void> showLocationPicker(BuildContext context, bool isDeparture) async {
    final selectedAirport = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPlace(
          selectedAirport: isDeparture ? (arrivalAirport?["code"]) : departureAirport?["code"],
        ),
      ),
    );

    if (selectedAirport != null) {
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

    if (result != null &&
        result.containsKey('adults') &&
        result.containsKey('childs') &&
        result.containsKey('infants')) {
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
    final formattedDate = departureDate != null
        ? DateFormat('yyyy-MM-dd').format(departureDate!)
        : null;

    return SearchTicketsTemp(
      departingDate: formattedDate,
      returningDate: null,
      passengerAdults: passengerAdults,
      passengerChilds: passengerChilds,
      passengerInfants: passengerInfants,
      departureAirportCode: departureAirport?['code'],
      arrivalAirportCode: arrivalAirport?['code'],
      seatClass: seatClass,
      isRoundTrip: false,
    );
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightTicketScreen(
          departureAirport: "${departureAirport?['city']} (${departureAirport?['code']})",
          arrivalAirport: "${arrivalAirport?['city']} (${arrivalAirport?['code']})",
          departureDate: departureDate!.toLocal().toString().split(' ')[0],
          returnDate: '',
          passengers: passengerAdults + passengerChilds + passengerInfants,
          seatClass: seatClass,
          passengerAdults: passengerAdults,
          passengerChilds: passengerChilds,
          passengerInfants: passengerInfants,
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
    passengerInfants = 0;
    seatClass = "Economy";

    notifyListeners();
  }
}
