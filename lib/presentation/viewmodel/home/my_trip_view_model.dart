import 'package:booking_flight/data/airport_data.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/data/trip_model.dart';
import 'package:booking_flight/presentation/view/home/Detail_flight_tickets.dart';
import 'package:booking_flight/presentation/viewmodel/home/detail_flight_tickets_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyTripViewModel extends ChangeNotifier {
  List<Trip> _allTrips = [];
  List<Trip> _recentTrips = [];
  bool _isLoading = true;
  String? _selectedTripId;

  List<Trip> get allTrips => _allTrips;
  List<Trip> get recentTrips => _recentTrips;
  bool get isLoading => _isLoading;
  String? get selectedTripId => _selectedTripId;

  MyTripViewModel() {
    _fetchTrips();
  }

  void selectTrip(String? tripId) {
    _selectedTripId = tripId;
    notifyListeners();
  }

  Future<void> _fetchTrips() async {
    debugPrint('=== Bắt đầu _fetchTrips ===');
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Đang truy vấn Firestore collection "trips"...');
      final querySnapshot = await FirebaseFirestore.instance.collection('trips').get();
      debugPrint('Đã nhận ${querySnapshot.docs.length} tài liệu từ Firestore');

      debugPrint('Chuyển đổi tài liệu thành đối tượng Trip...');
      final trips = querySnapshot.docs.map((doc) {
        final data = doc.data();
        debugPrint('Xử lý tài liệu ID: ${doc.id}, dữ liệu: $data');
        try {
          final trip = Trip.fromJson(data);
          debugPrint('Đã parse Trip: ID=${trip.id}, '
              'FlightData=${trip.flightData?.flightCode ?? "null"}, '
              'PassengerCount=${trip.passengers.length}, '
              'TotalAmount=${trip.totalAmount}');
          return trip;
        } catch (e) {
          debugPrint('Lỗi khi parse tài liệu ${doc.id}: $e');
          rethrow;
        }
      }).toList();

      debugPrint('Đã parse ${trips.length} Trips');

      trips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      debugPrint('Đã sắp xếp: First Trip createdAt=${trips.isNotEmpty ? trips.first.createdAt.toDate() : "N/A"}');

      final now = DateTime.now();
      final last7Days = now.subtract(const Duration(days: 7));
      debugPrint('Lọc recentTrips: now=$now, last7Days=$last7Days');

      _allTrips = trips;
      _recentTrips = trips
          .where((trip) {
        final createdAt = trip.createdAt.toDate();
        final isRecent = createdAt.isAfter(last7Days) && createdAt.isBefore(now);
        debugPrint('Trip ID=${trip.id}, createdAt=$createdAt, isRecent=$isRecent');
        return isRecent;
      })
          .toList();

      debugPrint('Kết quả: _allTrips=${_allTrips.length}, _recentTrips=${_recentTrips.length}');
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Lỗi khi lấy danh sách chuyến đi: $e');
      debugPrint('StackTrace: $stackTrace');
      _isLoading = false;
      showError('Không thể tải danh sách chuyến đi');
      notifyListeners();
    }
    debugPrint('=== Kết thúc _fetchTrips ===');
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

  void showError(String message) {
    debugPrint('Lỗi: $message');
    notifyListeners();
  }

  Future<void> showTicketDetailsSheet(
      BuildContext context,
      Trip trip, {
        dynamic searchViewModel,
      }) async {
    if (trip.flightData == null) {
      debugPrint('Lỗi: Dữ liệu chuyến bay rỗng');
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