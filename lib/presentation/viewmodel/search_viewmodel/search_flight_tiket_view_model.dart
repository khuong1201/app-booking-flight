import 'package:flutter/material.dart';
import '../../../data/search_flight_Data.dart';
import '../../../data/search_tickets_tmp_data.dart';
import '../../view/home/Detail_flight_tickets.dart';
import '../home/Detail_flight_tickets_view_model.dart';

class FlightTicketViewModel extends ChangeNotifier {
  FlightData flightData;
  final SearchTicketsTemp searchTicketData;
  int _searchOptionsTabIndex = 0;

  FlightTicketViewModel({
    required this.flightData,
    required this.searchTicketData,
  });
  int tabIndex = 0;
  // --- Basic Flight Information ---
  String get airlineLogo => flightData.airlineLogo;
  String get airlineName => flightData.airlineName;
  String get departureTime => flightData.departureTime;
  String get departureAirport => flightData.departureAirport;
  String get arrivalTime => flightData.arrivalTime;
  String get arrivalAirport => flightData.arrivalAirport;
  String get duration => flightData.duration;
  String get price => flightData.price;
  String get departureDate => flightData.departureDate;

  // --- Passenger Information from Search ---
  int get passengerAdults => searchTicketData.passengerAdults ;
  int get passengerChilds => searchTicketData.passengerChilds ;
  int get passengerInfants => searchTicketData.passengerInfants ;

  String get passengerCount {
    int total = passengerAdults + passengerChilds + passengerInfants;
    return "$total Pax";
  }

  // --- Search Criteria Display ---
  String get searchDepartureDate => searchTicketData.departingDate ?? 'Unknown';
  String get searchArrivalDate => searchTicketData.returningDate ?? 'Unknown';
  String get searchDepartureAirportCode =>
      searchTicketData.departureAirportCode ?? 'Unknown';
  String get searchArrivalAirportCode =>
      searchTicketData.arrivalAirportCode ?? 'Unknown';

  int get totalPassengerCount =>
      (searchTicketData.passengerAdults) +
          (searchTicketData.passengerChilds) +
          (searchTicketData.passengerInfants);

  // --- Tab Bar State for Search Options ---
  int get searchOptionsTabIndex => _searchOptionsTabIndex;

  void onSearchOptionsTabTapped(int index) {
    _searchOptionsTabIndex = index;
    notifyListeners();
  }

  // --- Data Update Method ---
  void updateFlightData(FlightData newFlightData) {
    flightData = newFlightData;
    notifyListeners();
  }

  // --- Static Methods for Data Handling ---
  static List<FlightTicketViewModel> fetchAllData(
      List<FlightData> flightDataList, SearchTicketsTemp searchTicketData) {
    return flightDataList
        .map((data) =>
        FlightTicketViewModel(flightData: data, searchTicketData: searchTicketData))
        .toList();
  }

  static List<FlightTicketViewModel> filterFlights({
    required List<FlightTicketViewModel> flights,
    required String departureInfo,
    required String arrivalInfo,
    required String date,
  }) {
    String extractAirportCode(String airportInfo) {
      RegExp regExp = RegExp(r'\((.*?)\)');
      Match? match = regExp.firstMatch(airportInfo);
      return match?.group(1) ?? '';
    }

    String filterDepartureCode = extractAirportCode(departureInfo);
    String filterArrivalCode = extractAirportCode(arrivalInfo);

    if (filterDepartureCode.isEmpty || filterArrivalCode.isEmpty) {
      print(
          "Error: Could not extract airport codes from input: $departureInfo / $arrivalInfo");
      return [];
    }

    DateTime filterDate;
    try {
      filterDate = DateTime.parse(date);
    } catch (e) {
      print("Error parsing filter date: $date");
      return [];
    }

    List<FlightTicketViewModel> filteredFlights = flights.where((flight) {
      bool matchesDeparture =
          flight.departureAirport.toLowerCase() == filterDepartureCode.toLowerCase();
      bool matchesArrival =
          flight.arrivalAirport.toLowerCase() == filterArrivalCode.toLowerCase();

      DateTime? flightDate;
      try {
        flightDate = DateTime.parse(flight.departureDate);
      } catch (e) {
        print("Error parsing flight date: ${flight.departureDate}");
        return false;
      }

      bool matchesDate = flightDate.year == filterDate.year &&
          flightDate.month == filterDate.month &&
          flightDate.day == filterDate.day;

      return matchesDeparture && matchesArrival && matchesDate;
    }).toList();

    print(
        "Filtering complete. Input: $filterDepartureCode -> $filterArrivalCode on $date. Found: ${filteredFlights.length} flights.");
    return filteredFlights;
  }

  static FlightTicketViewModel? findCheapestFlight(
      List<FlightTicketViewModel> flights) {
    if (flights.isEmpty) return null;

    flights.sort((a, b) {
      double priceA =
          double.tryParse(a.price.replaceAll(RegExp(r'[^\d.]'), '')) ??
              double.infinity;
      double priceB =
          double.tryParse(b.price.replaceAll(RegExp(r'[^\d.]'), '')) ??
              double.infinity;
      return priceA.compareTo(priceB);
    });

    return flights.first;
  }

  // --- Bottom Sheet for Ticket Details ---
  Future<void> showTicketDetailsSheet(BuildContext context) async {
    final detailViewModel = DetailFlightTicketsViewModel(
      searchTicketData: searchTicketData,
      flightData: flightData,
    );
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TicketDetailsView(
                  viewModel: detailViewModel,
                  onClose: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}