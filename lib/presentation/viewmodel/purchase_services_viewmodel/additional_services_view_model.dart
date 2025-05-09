import 'dart:convert';
import 'package:booking_flight/data/SearchViewModel.dart';
import 'package:booking_flight/data/additional_services_model.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/view/home/Detail_flight_tickets.dart';
import 'package:booking_flight/presentation/view/purcharse_services_view/payment_view.dart';
import 'package:booking_flight/presentation/viewmodel/home/detail_flight_tickets_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_flight/core/utils/caculator_price_total_passenger.dart';

class AdditionalServicesViewModel extends ChangeNotifier {
  double _totalAmount = 0;
  List<AdditionalServicesData> _additionalServices = [];
  final FlightData? flightData;
  final SearchViewModel? searchViewModel;
  final PassengerInfoViewModel passengerInfoViewModel;
  bool _comprehensiveInsurance = false;
  bool _flightDelayInsurance = false;
  final double comprehensiveInsuranceCost = 35000;
  final double flightDelayInsuranceCost = 35000;
  final PriceCalculator _pricingService = PriceCalculator();
  AdditionalServicesViewModel({
    this.flightData,
    this.searchViewModel,
    required this.passengerInfoViewModel,
  }) {
    _initAdditionalServices();
    _updateTotal();
  }

  double get totalAmount => _totalAmount;
  String get formattedTotalAmount => formatCurrency(_totalAmount);
  List<AdditionalServicesData> get additionalServices => _additionalServices;
  bool get comprehensiveInsurance => _comprehensiveInsurance;
  bool get flightDelayInsurance => _flightDelayInsurance;
  String get flightDateTime => _getFlightDateTime();
  String get airlineInfo => _getAirline();
  String get routerTrip =>
      '${flightData?.departureAirport ?? 'Unknown'} - ${flightData?.arrivalAirport ?? 'Unknown'}';
  String get logoAirPort => flightData?.airlineLogo ?? '';

  void _initAdditionalServices() {
    debugPrint('Passenger count: ${passengerInfoViewModel.passengers.length}');
    if (passengerInfoViewModel.passengers.isEmpty) {
      debugPrint('Warning: No passengers available');
      _additionalServices = [];
      return;
    }

    _additionalServices = passengerInfoViewModel.passengers
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final passenger = entry.value;
      if (!['Adult', 'Child', 'Infant'].contains(passenger.type)) {
        debugPrint('Warning: Invalid or missing type for passenger at index $index');
      }
      final service = AdditionalServicesData(
        passengerName: passengerInfoViewModel.getFullName(index),
        passengerType: passenger.type,
        passengerAge: passengerInfoViewModel.getAge(index).clamp(0, 150),
        comprehensiveInsuranceCost: 0,
        flightDelayInsuranceCost: 0,
      );
      debugPrint(
          'Initialized AdditionalServicesData: ${service.passengerName}, ${service.passengerType}, Age: ${service.passengerAge}');
      return service;
    }).toList();
    notifyListeners();
  }

  void updateBaggage(int index, String? baggage, double? cost) {
    if (index >= 0 && index < _additionalServices.length) {
      _additionalServices[index].updateBaggage(baggage, cost ?? 0.0);
      _updateTotal();
      notifyListeners();
    } else {
      debugPrint('Error: Invalid index $index for baggage update');
    }
  }

  void updateMeal(int index, String? meal, double? cost, int quantity) {
    if (index >= 0 && index < _additionalServices.length) {
      _additionalServices[index].updateMeal(meal, cost ?? 0.0, quantity);
      _updateTotal();
      notifyListeners();
    } else {
      debugPrint('Error: Invalid index $index for meal update');
    }
  }

  void updateSeatSelection(int index, String? seat, double? cost) {
    if (index >= 0 && index < _additionalServices.length) {
      debugPrint('Updating seat for passenger $index: $seat, cost: $cost');
      _additionalServices[index].updateSeat(seat, cost ?? 0.0);
      _updateTotal();
      notifyListeners();
    } else {
      debugPrint('Error: Invalid index $index for seat selection');
    }
  }

  void toggleComprehensiveInsurance(bool value) {
    _comprehensiveInsurance = value;
    for (var service in _additionalServices) {
      service.updateComprehensiveInsurance(value, comprehensiveInsuranceCost);
    }
    _updateTotal();
    notifyListeners();
  }

  void toggleFlightDelayInsurance(bool value) {
    _flightDelayInsurance = value;
    for (var service in _additionalServices) {
      service.updateFlightDelayInsurance(value, flightDelayInsuranceCost);
    }
    _updateTotal();
    notifyListeners();
  }

  void _updateTotal() {
    double totalPrice = _pricingService.getBaseFareNumeric(passengerInfoViewModel.totalAmount);
    final additionalServicesCost = _additionalServices.fold(
      0.0,
          (sum, service) => sum + service.totalCost,
    );
    _totalAmount = totalPrice + additionalServicesCost;
    if (_totalAmount.isInfinite || _totalAmount.isNaN) {
      debugPrint('Warning: Total amount is invalid: $_totalAmount');
      _totalAmount = 0;
    }
  }

  void addService(String service) {
    debugPrint("Added service: $service");
    notifyListeners();
  }

  void continueAction(BuildContext context) {
    if (flightData == null || searchViewModel == null) {
      debugPrint('Error: flightData or searchViewModel is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tiếp tục: Dữ liệu chuyến bay không hợp lệ')),
      );
      return;
    }

    final additionalServicesJson = _additionalServices.map((service) => service.toJson()).toList();
    debugPrint("Continue pressed with total: $_totalAmount VND");
    debugPrint("Additional Services Data (JSON):");
    debugPrint(const JsonEncoder.withIndent('  ').convert(additionalServicesJson));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          flightData: flightData!,
          searchViewModel: searchViewModel!,
          passengerInfoViewModel: passengerInfoViewModel,
          additionalServicesViewModel: this,
        ),
      ),
    );
  }

  Future<void> showTicketDetailsSheet(BuildContext context) async {
    if (flightData == null) {
      debugPrint('Lỗi: Dữ liệu chuyến bay rỗng');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có dữ liệu chuyến bay')),
      );
      return;
    }

    final detailViewModel = DetailFlightTicketsViewModel(
      searchViewModel: searchViewModel,
      flightData: flightData,
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ChangeNotifierProvider<DetailFlightTicketsViewModel>(
          create: (_) => detailViewModel,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            height: MediaQuery.of(context).size.height * 0.9,
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
        );
      },
    );
  }

  String _getFlightDateTime() {
    if (flightData == null) {
      return "Không có thông tin";
    }

    final date = flightData!.departureDate;
    final startTime = flightData!.departureTime;
    final endTime = flightData!.arrivalTime;

    if (date.isEmpty || startTime.isEmpty || endTime.isEmpty) {
      return "Không có thông tin";
    }

    final formattedDate = _formatDate(date);
    return "$formattedDate • $startTime - $endTime";
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      final dayOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][parsedDate.weekday - 1];
      final month = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ][parsedDate.month - 1];
      final day = parsedDate.day.toString().padLeft(2, '0');
      return "$dayOfWeek, $month $day";
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return "Không có thông tin";
    }
  }

  String _getAirline() {
    if (flightData == null) {
      return "Không có thông tin";
    }

    final airline = flightData!.airlineName;
    return airline;
  }

  double parsePrice(String? price) {
    if (price == null || price.isEmpty) {
      debugPrint('Warning: Price is null or empty');
      return 0.0;
    }
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

  String formatCurrency(double amount) {
    if (amount.isNaN || amount.isInfinite) {
      debugPrint('Warning: Invalid amount for formatting: $amount');
      return '0';
    }
    final formatted = amount.toStringAsFixed(0);
    return formatted.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}