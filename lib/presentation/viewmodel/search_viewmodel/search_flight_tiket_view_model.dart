import 'package:booking_flight/core/utils/caculator_price_total_passenger.dart';
import 'package:booking_flight/presentation/viewmodel/home/detail_flight_tickets_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../data/search_flight_data.dart';
import '../../view/home/Detail_flight_tickets.dart';
import '../../../data/SearchViewModel.dart';

class FlightTicketViewModel extends ChangeNotifier {
  FlightData? _flightData;
  final SearchViewModel? searchViewModel;
  int _searchOptionsTabIndex = 0;
  final PriceCalculator _pricingService = PriceCalculator(); // Khởi tạo PriceCalculator

  FlightTicketViewModel({
    required FlightData? flightData,
    required this.searchViewModel,
  }) : _flightData = flightData;

  // --- Getters for Basic Flight Information ---
  String get airlineLogo => _flightData?.airlineLogo ?? '';
  String get airlineName => _flightData?.airlineName ?? '';
  String get departureTime => _flightData?.departureTime ?? '';
  String get departureAirport => _flightData?.departureAirport ?? '';
  String get arrivalTime => _flightData?.arrivalTime ?? '';
  String get arrivalAirport => _flightData?.arrivalAirport ?? '';
  String get duration => _flightData?.duration ?? '';
  String get basePrice => _flightData?.price ?? '';
  String get departureDate => _flightData?.departureDate ?? '';
  String? get returnDate => _flightData?.returnDate;
  String? get returnDepartureTime => _flightData?.returnDepartureTime;
  String? get returnArrivalTime => _flightData?.returnArrivalTime;

  // --- Passenger Information from Search ---
  int get passengerAdults => searchViewModel?.passengerAdults ?? 0;
  int get passengerChilds => searchViewModel?.passengerChilds ?? 0;
  int get passengerInfants => searchViewModel?.passengerInfants ?? 0;
  String get seatClass => searchViewModel?.seatClass ?? "Economy";

  String get passengerCount {
    final total = passengerAdults + passengerChilds + passengerInfants;
    return '$total Pax';
  }

  // --- Total Price Calculation ---
  String get totalPrice => _pricingService.calculateTotalPrice(
    basePrice: _flightData?.price ?? '',
    adults: passengerAdults,
    children: passengerChilds,
    infants: passengerInfants,
  );

  // Thêm phương thức calculateTotalAmount để hỗ trợ findCheapestFlight
  double calculateTotalAmount() => _pricingService.calculateTotalAmount(
    basePrice: _flightData?.price ?? '',
    adults: passengerAdults,
    children: passengerChilds,
    infants: passengerInfants,
  );

  // --- Search Criteria Display ---
  String get searchDepartureDate {
    final departureDate = searchViewModel?.departureDate;
    return departureDate != null
        ? DateFormat('yyyy-MM-dd').format(departureDate)
        : 'Unknown';
  }

  String get searchArrivalDate {
    final returnDate = searchViewModel?.returnDate;
    return returnDate != null
        ? DateFormat('yyyy-MM-dd').format(returnDate)
        : 'Unknown';
  }

  String get searchDepartureAirportCode {
    return searchViewModel?.departureAirport?['code'] ?? 'Unknown';
  }

  String get searchArrivalAirportCode {
    return searchViewModel?.arrivalAirport?['code'] ?? 'Unknown';
  }

  int get totalPassengerCount =>
      passengerAdults + passengerChilds + passengerInfants;

  // --- Tab Bar State for Search Options ---
  int get searchOptionsTabIndex => _searchOptionsTabIndex;

  void onSearchOptionsTabTapped(int index) {
    _searchOptionsTabIndex = index;
    notifyListeners();
  }

  // --- Data Update Method ---
  void updateFlightData(FlightData? newFlightData) {
    _flightData = newFlightData;
    notifyListeners();
  }

  // --- Utility Methods ---
  static double _parsePrice(String price) {
    try {
      String cleanedPrice = price.replaceAll('VND', '').trim();
      cleanedPrice = cleanedPrice.replaceAll('.', '');
      cleanedPrice = cleanedPrice.replaceAll(',', '.');
      return double.parse(cleanedPrice);
    } catch (e) {
      debugPrint('Lỗi phân tích giá: $e với đầu vào: $price');
      return 0.0;
    }
  }

  static DateTime? _parseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      return null;
    }
  }

  // --- Static Methods for Data Handling ---
  static List<FlightTicketViewModel> fetchAllData(
      List<FlightData> flightDataList, SearchViewModel? searchViewModel) {
    return flightDataList
        .map((data) => FlightTicketViewModel(
      flightData: data,
      searchViewModel: searchViewModel,
    ))
        .toList();
  }

  static List<FlightTicketViewModel> filterFlights({
    required List<FlightTicketViewModel> flights,
    required String departureInfo,
    required String arrivalInfo,
    required String date,
    bool isRoundTrip = false,
    String? returnDate,
  }) {
    String extractAirportCode(String airportInfo) {
      final regExp = RegExp(r'\((.*?)\)');
      final match = regExp.firstMatch(airportInfo);
      return match?.group(1)?.toLowerCase() ?? '';
    }

    final filterDepartureCode = extractAirportCode(departureInfo);
    final filterArrivalCode = extractAirportCode(arrivalInfo);

    if (filterDepartureCode.isEmpty || filterArrivalCode.isEmpty) {
      debugPrint(
          'Error: Could not extract airport codes from input: $departureInfo / $arrivalInfo');
      return [];
    }

    final filterDate = _parseDate(date);
    if (filterDate == null) {
      debugPrint('Error parsing filter date: $date');
      return [];
    }

    DateTime? filterReturnDate;
    if (isRoundTrip && returnDate != null) {
      filterReturnDate = _parseDate(returnDate);
      if (filterReturnDate == null) {
        debugPrint('Error parsing return date: $returnDate');
        return [];
      }
    }

    final filteredFlights = flights.where((flight) {
      final matchesDeparture =
          flight.departureAirport.toLowerCase() == filterDepartureCode;
      final matchesArrival =
          flight.arrivalAirport.toLowerCase() == filterArrivalCode;

      final flightDate = _parseDate(flight.departureDate);
      final matchesDate = flightDate != null &&
          flightDate.year == filterDate.year &&
          flightDate.month == filterDate.month &&
          flightDate.day == filterDate.day;

      bool matchesReturnDate = true;
      if (isRoundTrip && filterReturnDate != null) {
        final flightReturnDate = flight.returnDate != null
            ? _parseDate(flight.returnDate!)
            : null;
        matchesReturnDate = flightReturnDate != null &&
            flightReturnDate.year == filterReturnDate.year &&
            flightReturnDate.month == filterReturnDate.month &&
            flightReturnDate.day == filterReturnDate.day;
      }

      bool isValidForOneWay = !isRoundTrip ? flight.returnDate == null : true;

      return matchesDeparture &&
          matchesArrival &&
          matchesDate &&
          (!isRoundTrip || matchesReturnDate) &&
          isValidForOneWay;
    }).toList();

    debugPrint(
        'Filtering complete. Input: $filterDepartureCode -> $filterArrivalCode on $date${isRoundTrip ? ' (Round-trip, return: $returnDate)' : ''}. Found: ${filteredFlights.length} flights.');
    return filteredFlights;
  }

  static FlightTicketViewModel? findCheapestFlight(
      List<FlightTicketViewModel> flights) {
    if (flights.isEmpty) return null;

    return flights.reduce((a, b) {
      final priceA = a.calculateTotalAmount();
      final priceB = b.calculateTotalAmount();
      return priceA <= priceB ? a : b;
    });
  }

  // --- Bottom Sheet for Ticket Details ---
  Future<void> showTicketDetailsSheet(BuildContext context) async {
    if (_flightData == null) {
      debugPrint('Error: Flight data is null');
      return;
    }

    final detailViewModel = DetailFlightTicketsViewModel(
      searchViewModel: searchViewModel,
      flightData: _flightData,
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ChangeNotifierProvider<DetailFlightTicketsViewModel>(
          create: (_) => detailViewModel,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<DetailFlightTicketsViewModel>(
                    builder: (context, viewModel, _) => TicketDetailsView(
                      viewModel: viewModel,
                      onClose: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}