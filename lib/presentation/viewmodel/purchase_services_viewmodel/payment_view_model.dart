import 'package:booking_flight/data/additional_services_model.dart';
import 'package:booking_flight/data/passenger_infor_model.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/data/trip_model.dart';
import 'package:booking_flight/presentation/view/home/booking_flight_view.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/additional_services_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_flight/data/SearchViewModel.dart';

class PaymentViewModel extends ChangeNotifier {
  final FlightData flightData;
  final SearchViewModel searchViewModel;
  final PassengerInfoViewModel passengerInfoViewModel;
  final AdditionalServicesViewModel additionalServicesViewModel;
  bool _isLoading = false;
  String? _currentOrderId;
  BuildContext? _paymentContext;

  // Computed properties
  double _flightPrice = 0.0;
  double _additionalServicesTotal = 0.0;
  double _insuranceTotal = 0.0;
  double _totalAmount = 0.0;

  bool get isLoading => _isLoading;
  int get passengerCount => passengerInfoViewModel.passengers.length;
  List<AdditionalServicesData> get additionalServices => additionalServicesViewModel.additionalServices;
  String get formattedFlightPrice => formatCurrency(_flightPrice);
  String get formattedAdditionalServicesTotal => formatCurrency(_additionalServicesTotal);
  String get formattedInsuranceTotal => formatCurrency(_insuranceTotal);
  String get formattedTotalAmount => formatCurrency(_totalAmount);

  PaymentViewModel({
    required this.flightData,
    required this.searchViewModel,
    required this.passengerInfoViewModel,
    required this.additionalServicesViewModel,
  }) {
    _initialize();
  }

  void _initialize() {
    _calculateTotals();
  }

  void _calculateTotals() {
    // Parse flight price from flightData
    _flightPrice = additionalServicesViewModel.parsePrice(passengerInfoViewModel.totalAmount);

    // Calculate additional services total (baggage, seats, meals)
    _additionalServicesTotal = additionalServicesViewModel.additionalServices.fold<double>(
      0.0,
          (sum, service) => sum + (service.baggageCost + service.seatCost + service.mealCost),
    );

    // Calculate insurance total based on selected insurance options
    _insuranceTotal = additionalServicesViewModel.additionalServices.fold<double>(
      0.0,
          (sum, service) => sum + (service.comprehensiveInsuranceCost + service.flightDelayInsuranceCost),
    );

    // Calculate total amount
    _totalAmount = _flightPrice + _additionalServicesTotal + _insuranceTotal;

    debugPrint(
        'Calculated Totals: Flight Price: $_flightPrice, Additional Services: $_additionalServicesTotal, Insurance: $_insuranceTotal, Total: $_totalAmount');

    if (_totalAmount.isNaN || _totalAmount.isInfinite) {
      debugPrint('Warning: Total amount is invalid: $_totalAmount');
      _totalAmount = 0.0;
    }

    notifyListeners();
  }

  Future<void> saveTrip(String contactId, Trip trip) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(contactId)
          .collection('trips')
          .doc(trip.id)
          .set(trip.toJson());

      // Lưu thông tin ContactInfo vào document user
      await FirebaseFirestore.instance.collection('users').doc(contactId).set({
        'contactInfo': ContactInfo(
          phoneNumber: contactId.contains('@') ? null : contactId,
          email: contactId.contains('@') ? contactId : null,
        ).toJson(),
      }, SetOptions(merge: true));

      debugPrint('Trip saved successfully for contactId: $contactId');
    } catch (e) {
      debugPrint('Error saving trip: $e');
      throw Exception('Failed to save trip: $e');
    }
  }

  Future<void> _saveTripToFirestore() async {
    try {
      // Lấy contactId từ hành khách đầu tiên (giả định người đặt vé chính)
      final passengers = passengerInfoViewModel.passengers;
      if (passengers.isEmpty) {
        throw Exception('No passengers found');
      }

      final contactId = passengers.first.contactInfo?.phoneNumber ??
          passengers.first.contactInfo?.email;
      if (contactId == null) {
        throw Exception('No contact information (phone or email) found for passenger');
      }

      // Chuyển đổi AdditionalServicesData thành Map để lưu vào Trip
      final additionalServicesData = additionalServicesViewModel.additionalServices
          .map((service) => {
        'baggageCost': service.baggageCost,
        'seatCost': service.seatCost,
        'mealCost': service.mealCost,
        'comprehensiveInsuranceCost': service.comprehensiveInsuranceCost,
        'flightDelayInsuranceCost': service.flightDelayInsuranceCost,
      })
          .toList();

      // Tạo Trip object
      final trip = Trip(
        id: _currentOrderId ?? 'TRIP_${DateTime.now().millisecondsSinceEpoch}',
        flightData: flightData,
        passengers: passengers,
        additionalServices: additionalServicesData,
        totalAmount: _totalAmount,
        createdAt: Timestamp.now(),
      );

      // Lưu Trip vào Firestore
      await saveTrip(contactId, trip);
    } catch (e) {
      debugPrint('Error in _saveTripToFirestore: $e');
      if (_paymentContext != null) {
        ScaffoldMessenger.of(_paymentContext!).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Failed to save trip: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }
  }

  Future<void> initiatePayment(BuildContext context) async {
    _paymentContext = context;
    _isLoading = true;
    _currentOrderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";
    notifyListeners();

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Save data to Firestore
      await _saveTripToFirestore();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '✅ Payment successful (simulated)!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to HomeScreen
      Navigator.popUntil(context, (route) {
        return route.settings.name == '/homeScreen' || route.isFirst;
      });

      if (ModalRoute.of(context)?.settings.name != '/homeScreen') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookingFlightScreen()),
        );
      }
    } catch (e) {
      debugPrint('Payment initiation failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '❌ Payment failed: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
      _currentOrderId = null;
      _paymentContext = null;
      notifyListeners();
    }
  }

  String formatCurrency(double amount) {
    if (amount.isNaN || amount.isInfinite) {
      debugPrint('Warning: Invalid amount for formatting: $amount');
      return '0';
    }
    final formatted = amount.toStringAsFixed(0);
    return formatted.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  void dispose() {
    _paymentContext = null;
    super.dispose();
  }
}