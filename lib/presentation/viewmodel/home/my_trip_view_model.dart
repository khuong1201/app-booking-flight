import 'package:booking_flight/data/SearchViewModel.dart';
import 'package:booking_flight/data/trip_model.dart';
import 'package:booking_flight/presentation/view/home/detail_flight_tickets.dart';
import 'package:booking_flight/presentation/viewmodel/home/detail_flight_tickets_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyTripViewModel extends ChangeNotifier {
  List<Trip> _allTrips = [];
  List<Trip> _recentTrips = [];
  List<Trip> _filteredAllTrips = [];
  List<Trip> _filteredRecentTrips = [];
  bool _isLoading = true;
  String? _selectedTripId;
  String _searchQuery = '';
  final String contactId;

  List<Trip> get allTrips => _filteredAllTrips;
  List<Trip> get recentTrips => _filteredRecentTrips;
  bool get isLoading => _isLoading;
  String? get selectedTripId => _selectedTripId;

  MyTripViewModel({required this.contactId});

  void selectTrip(String? tripId) {
    _selectedTripId = tripId;
    notifyListeners();
  }

  void filterTrips(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredAllTrips = _allTrips;
      _filteredRecentTrips = _recentTrips;
    } else {
      _filteredAllTrips = _allTrips.where((trip) {
        final flightData = trip.flightData;
        if (flightData == null) return false;
        return flightData.flightCode?.toLowerCase().contains(_searchQuery) == true ||
            flightData.departureAirport.toLowerCase().contains(_searchQuery) ||
            flightData.arrivalAirport.toLowerCase().contains(_searchQuery);
      }).toList();
      _filteredRecentTrips = _recentTrips.where((trip) {
        final flightData = trip.flightData;
        if (flightData == null) return false;
        return flightData.flightCode?.toLowerCase().contains(_searchQuery) == true ||
            flightData.departureAirport.toLowerCase().contains(_searchQuery) ||
            flightData.arrivalAirport.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchTrips() async {
    debugPrint('Fetching trips for contactId: $contactId');
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(contactId)
          .collection('trips')
          .get();

      debugPrint('Retrieved ${querySnapshot.docs.length} trips from Firestore');

      final trips = querySnapshot.docs.map((doc) {
        debugPrint('Processing trip ID: ${doc.id}');
        try {
          final trip = Trip.fromFirestore(doc);
          debugPrint('Parsed trip: ID=${trip.id}, '
              'FlightCode=${trip.flightData?.flightCode ?? "null"}, '
              'Passengers=${trip.passengers.length}, '
              'TotalAmount=${trip.totalAmount}');
          return trip;
        } catch (e) {
          debugPrint('Error parsing trip ${doc.id}: $e');
          rethrow;
        }
      }).toList();

      // Sort trips by createdAt (newest first)
      trips.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Filter recent trips (last 7 days)
      final now = DateTime.now();
      final last7Days = now.subtract(const Duration(days: 7));
      _allTrips = trips;
      _recentTrips = trips.where((trip) {
        final createdAt = trip.createdAt.toDate();
        final isRecent = createdAt.isAfter(last7Days) && createdAt.isBefore(now);
        return isRecent;
      }).toList();

      // Initialize filtered lists
      _filteredAllTrips = _allTrips;
      _filteredRecentTrips = _recentTrips;

      // Apply search filter if query exists
      if (_searchQuery.isNotEmpty) {
        filterTrips(_searchQuery);
      }

      debugPrint('Loaded: allTrips=${_allTrips.length}, recentTrips=${_recentTrips.length}');
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error fetching trips: $e\nStackTrace: $stackTrace');
      _isLoading = false;
      showError('Không thể tải danh sách chuyến đi', context: null);
      notifyListeners();
    }
  }

  String formatCurrency(String price) {
    final cleanedPrice = price.replaceAll(' VND', '').replaceAll('.', '');
    final amount = double.tryParse(cleanedPrice) ?? 0.0;
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return '${formatter.format(amount).trim()} VND';
  }

  String formatDateTime(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final dateFormat = DateFormat('EEE, dd MMM • HH:mm', 'vi_VN');
    return dateFormat.format(dateTime);
  }

  void showError(String message, {BuildContext? context}) {
    debugPrint('Error: $message');
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
    notifyListeners();
  }

  Future<void> showTicketDetailsSheet(
      BuildContext context,
      Trip trip, {
        SearchViewModel? searchViewModel,
      }) async {
    if (trip.flightData == null) {
      debugPrint('Error: No flight data available for trip ${trip.id}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có dữ liệu chuyến bay')),
      );
      return;
    }

    final detailViewModel = DetailFlightTicketsViewModel(
      flightData: trip.flightData!,
      searchViewModel: searchViewModel,
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ChangeNotifierProvider<DetailFlightTicketsViewModel>(
          create: (_) => detailViewModel,
          child: FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
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
          ),
        );
      },
    );
  }
}