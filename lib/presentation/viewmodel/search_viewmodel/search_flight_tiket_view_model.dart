import 'dart:async';
import 'package:booking_flight/core/utils/caculator_price_total_passenger.dart';
import 'package:booking_flight/data/SearchViewModel.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/view/home/detail_flight_tickets.dart';
import 'package:booking_flight/presentation/viewmodel/home/detail_flight_tickets_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FlightTicketViewModel extends ChangeNotifier {
  List<FlightData> _flights = [];
  FlightData? _selectedFlight;
  final SearchViewModel? searchViewModel;
  final PriceCalculator _pricingService = PriceCalculator();
  final Map<String, List<FlightData>> _flightCache = {};
  StreamSubscription<DocumentSnapshot>? _flightSubscription;
  final StreamController<List<FlightData>> _flightStreamController = StreamController<List<FlightData>>.broadcast();

  FlightTicketViewModel({this.searchViewModel}) {
    // Defer fetchFlights to avoid synchronous state changes during initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchFlights();
    });
  }

  // Getters for UI
  List<FlightData> get flights => _flights;
  Stream<List<FlightData>> get flightStream => _flightStreamController.stream;
  String get airlineLogo => _selectedFlight?.airlineLogo ?? '';
  String get airlineName => _selectedFlight?.airlineName ?? '';
  String get departureTime => _selectedFlight?.departureTime ?? '';
  String get departureAirport => _selectedFlight?.departureAirport ?? '';
  String get arrivalTime => _selectedFlight?.arrivalTime ?? '';
  String get arrivalAirport => _selectedFlight?.arrivalAirport ?? '';
  String get duration => _selectedFlight?.duration ?? '';
  String get price => _pricingService.calculateTotalPrice(
    basePrice: _selectedFlight?.price ?? '',
    adults: passengerAdults,
    children: passengerChilds,
    infants: passengerInfants,
  );
  String get passengerCount {
    final total = passengerAdults + passengerChilds + passengerInfants;
    return '$total Pax';
  }

  // Passenger and search data
  int get passengerAdults => searchViewModel?.passengerAdults ?? 0;
  int get passengerChilds => searchViewModel?.passengerChilds ?? 0;
  int get passengerInfants => searchViewModel?.passengerInfants ?? 0;
  String get searchDepartureDate =>
      searchViewModel?.departureDate != null
          ? DateFormat('yyyy-MM-dd').format(searchViewModel!.departureDate!)
          : '';
  String get searchArrivalDate =>
      searchViewModel?.returnDate != null
          ? DateFormat('yyyy-MM-dd').format(searchViewModel!.returnDate!)
          : '';
  String get searchDepartureAirportCode =>
      searchViewModel?.departureAirport?['code']?.toString() ?? '';
  String get searchArrivalAirportCode =>
      searchViewModel?.arrivalAirport?['code']?.toString() ?? '';

  Future<void> fetchFlights() async {
    if (searchViewModel == null) {
      debugPrint('❌ Error: SearchViewModel is null');
      _flights = [];
      _selectedFlight = null;
      _flightStreamController.add([]);
      notifyListeners();
      return;
    }

    try {
      final departureDate = searchDepartureDate;
      final departureAirport = searchDepartureAirportCode;
      final arrivalAirport = searchArrivalAirportCode;
      final cacheKey = '$departureDate-$departureAirport-$arrivalAirport';

      debugPrint('🔍 Fetching flights for $cacheKey');

      // Check cache first
      if (_flightCache.containsKey(cacheKey)) {
        debugPrint('✅ Using cached flights for $cacheKey');
        _flights = _flightCache[cacheKey]!;
        _selectedFlight = _flights.isNotEmpty ? _flights.first : null;
        _flightStreamController.add(_flights);
        notifyListeners();
        return;
      }

      // Cancel existing subscription
      await _flightSubscription?.cancel();

      // Set up Firestore stream
      _flightSubscription = FirebaseFirestore.instance
          .collection('flights')
          .doc(departureDate)
          .collection(departureAirport)
          .doc(arrivalAirport)
          .snapshots()
          .listen((docSnapshot) {
        List<FlightData> newFlights = [];
        if (docSnapshot.exists) {
          final flight = FlightData.fromFirestore(docSnapshot);
          // Check if flight matches one-way or round-trip criteria
          if (searchViewModel!.returnDate != null) {
            if (flight.returnDate == searchArrivalDate) {
              newFlights = [flight];
            }
          } else {
            if (flight.returnDate == null) {
              newFlights = [flight];
            }
          }
        }

        _flights = newFlights;
        _selectedFlight = _flights.isNotEmpty ? _flights.first : null;
        _flightCache[cacheKey] = _flights;
        _flightStreamController.add(_flights);
        notifyListeners();
        debugPrint('✅ Streamed ${_flights.length} flights');
      }, onError: (e) {
        debugPrint('❌ Error streaming flights: $e');
        _flights = [];
        _selectedFlight = null;
        _flightCache[cacheKey] = [];
        _flightStreamController.add([]);
        notifyListeners();
      });
    } catch (e) {
      debugPrint('❌ Error fetching flights: $e');
      _flights = [];
      _selectedFlight = null;
      _flightStreamController.add([]);
      notifyListeners();
    }
  }

  void selectFlight(FlightData flight) {
    _selectedFlight = flight;
    notifyListeners();
  }

  FlightData? findCheapestFlight() {
    if (_flights.isEmpty) return null;
    return _flights.reduce((a, b) {
      final aPrice = _pricingService.calculateTotalAmount(
        basePrice: a.price,
        adults: passengerAdults,
        children: passengerChilds,
        infants: passengerInfants,
      );
      final bPrice = _pricingService.calculateTotalAmount(
        basePrice: b.price,
        adults: passengerAdults,
        children: passengerChilds,
        infants: passengerInfants,
      );
      return aPrice < bPrice ? a : b;
    });
  }

  Future<void> showTicketDetailsSheet(BuildContext context) async {
    if (_selectedFlight == null) {
      debugPrint('❌ Error: No selected flight');
      return;
    }

    final detailViewModel = DetailFlightTicketsViewModel(
      searchViewModel: searchViewModel,
      flightData: _selectedFlight,
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChangeNotifierProvider<DetailFlightTicketsViewModel>(
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
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('🗑️ Disposing FlightTicketViewModel');
    _flightSubscription?.cancel();
    if (!_flightStreamController.isClosed) {
      _flightStreamController.close();
    }
    super.dispose();
  }
}