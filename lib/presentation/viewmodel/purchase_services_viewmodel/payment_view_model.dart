import 'package:booking_flight/core/utils/validator_utils.dart';
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
    _flightPrice = additionalServicesViewModel.parsePrice(passengerInfoViewModel.totalAmount);
    _additionalServicesTotal = additionalServicesViewModel.additionalServices.fold<double>(
      0.0,
          (sum, service) => sum + (service.baggageCost + service.seatCost + service.mealCost),
    );
    _insuranceTotal = additionalServicesViewModel.additionalServices.fold<double>(
      0.0,
          (sum, service) => sum + (service.comprehensiveInsuranceCost + service.flightDelayInsuranceCost),
    );
    _totalAmount = _flightPrice + _additionalServicesTotal + _insuranceTotal;

    debugPrint(
        'Calculated Totals: Flight Price: $_flightPrice, Additional Services: $_additionalServicesTotal, Insurance: $_insuranceTotal, Total: $_totalAmount');

    if (_totalAmount.isNaN || _totalAmount.isInfinite) {
      debugPrint('Warning: Total amount is invalid: $_totalAmount');
      _totalAmount = 0.0;
    }

    notifyListeners();
  }

  Future<void> saveTrip(String identifier, Trip trip) async {
    try {
      // Validate identifier
      if (identifier.isEmpty) {
        debugPrint('Error: Identifier is empty');
        throw Exception('Email or phone number is required');
      }
      if (!ValidatorUtils.isValidEmail(identifier) && !ValidatorUtils.isValidPhone(identifier)) {
        debugPrint('Error: Invalid identifier: $identifier');
        throw Exception('Invalid email or phone number');
      }

      // Validate contactInfo
      final contactInfo = trip.contactInfo;
      if (contactInfo == null) {
        debugPrint('Error: Trip contactInfo is null');
        throw Exception('Contact info is required');
      }
      if (contactInfo.email != identifier && contactInfo.phoneNumber != identifier) {
        debugPrint('Error: contactInfo (email: ${contactInfo.email}, phone: ${contactInfo.phoneNumber}) does not match identifier: $identifier');
        throw Exception('Contact info must match the provided email or phone number');
      }

      // Log the Firestore document data
      final tripData = trip.toFirestore();
      debugPrint('Saving trip to users/$identifier/trips/${trip.id} with data: $tripData');

      // Save trip
      await FirebaseFirestore.instance
          .collection('users')
          .doc(identifier)
          .collection('trips')
          .doc(trip.id)
          .set(tripData);

      // Save contactInfo
      final contactInfoData = {
        'contactInfo': contactInfo.toJson(),
        'lastUpdated': Timestamp.now(),
      };
      debugPrint('Saving contact info to users/$identifier with data: $contactInfoData');
      await FirebaseFirestore.instance.collection('users').doc(identifier).set(
        contactInfoData,
        SetOptions(merge: true),
      );

      debugPrint('Trip and contact info saved successfully for identifier: $identifier');
    } catch (e) {
      debugPrint('Error saving trip or contact info: $e');
      throw Exception('Failed to save trip or contact info: $e');
    }
  }

  Future<void> _saveTripToFirestore() async {
    try {
      final passengers = passengerInfoViewModel.passengers;
      if (passengers.isEmpty) {
        debugPrint('Error: No passengers found');
        throw Exception('No passengers found');
      }

      debugPrint('Passenger count: ${passengers.length}');
      for (var i = 0; i < passengers.length; i++) {
        debugPrint('Passenger $i: ${passengers[i].toJson()}');
      }

      final viewModelJson = passengerInfoViewModel.toJson();
      debugPrint('PassengerInfoViewModel JSON: $viewModelJson');

      final contactInfoJson = viewModelJson['contactInfo'] as Map<String, dynamic>?;
      if (contactInfoJson == null ||
          (contactInfoJson['email']?.toString().isEmpty ?? true) &&
              (contactInfoJson['phoneNumber']?.toString().isEmpty ?? true)) {
        debugPrint('Error: No valid contact information found');
        throw Exception('No valid contact information (phone or email) found');
      }

      final contactInfo = ContactInfo(
        phoneNumber: contactInfoJson['phoneNumber'] as String?,
        email: contactInfoJson['email'] as String?,
      );

      final identifier = contactInfo.email ?? contactInfo.phoneNumber;
      if (identifier == null || identifier.isEmpty) {
        debugPrint('Error: No valid email or phoneNumber found');
        throw Exception('No valid email or phone number found');
      }

      debugPrint('Using identifier: $identifier');

      final additionalServicesData = additionalServicesViewModel.additionalServices.map((service) {
        return {
          'baggageCost': service.baggageCost,
          'seatCost': service.seatCost,
          'mealCost': service.mealCost,
          'comprehensiveInsuranceCost': service.comprehensiveInsuranceCost,
          'flightDelayInsuranceCost': service.flightDelayInsuranceCost,
        };
      }).toList();

      final trip = Trip(
        id: _currentOrderId ?? 'TRIP_${DateTime.now().millisecondsSinceEpoch}',
        flightData: flightData,
        passengers: passengers,
        contactInfo: contactInfo,
        additionalServices: additionalServicesData,
        totalAmount: _totalAmount,
        createdAt: Timestamp.now(),
      );

      await saveTrip(identifier, trip);
      debugPrint('Trip saved to Firestore for identifier: $identifier');
    } catch (e) {
      debugPrint('Error in _saveTripToFirestore: $e');
      if (_paymentContext != null && _paymentContext!.mounted) {
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
    _currentOrderId = 'ORDER_${DateTime.now().millisecondsSinceEpoch}';
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate payment
      await _saveTripToFirestore();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '✅ Payment successful (simulated)!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.popUntil(context, (route) {
          return route.settings.name == '/homeScreen' || route.isFirst;
        });

        if (ModalRoute.of(context)?.settings.name != '/homeScreen' && context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookingFlightScreen()),
          );
        }
      }
    } catch (e) {
      debugPrint('Payment initiation failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Payment failed: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  @override
  void dispose() {
    debugPrint('Disposing PaymentViewModel');
    _paymentContext = null;
    super.dispose();
  }
}