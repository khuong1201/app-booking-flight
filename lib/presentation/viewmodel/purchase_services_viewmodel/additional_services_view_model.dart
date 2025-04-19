import 'package:booking_flight/data/additional_services_data.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/view/home/Detail_flight_tickets.dart';
import 'package:booking_flight/presentation/viewmodel/home/Detail_flight_tickets_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/SearchViewModel.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdditionalServicesViewModel extends ChangeNotifier {
  bool _comprehensiveInsurance = true;
  bool _flightDelayInsurance = false;
  double _totalAmount = 0;
  List<AdditionalServicesData> _additionalServices = [];
  final FlightData? flightData;
  final SearchViewModel? searchViewModel;
  final PassengerInfoViewModel passengerInfoViewModel;
  final double comprehensiveInsuranceCost = 35000;
  final double flightDelayInsuranceCost = 35000;

  AdditionalServicesViewModel({
    this.flightData,
    this.searchViewModel,
    required this.passengerInfoViewModel,
  }) {
    _initAdditionalServices();
    _updateTotal();
  }

  bool get comprehensiveInsurance => _comprehensiveInsurance;
  bool get flightDelayInsurance => _flightDelayInsurance;
  double get totalAmount => _totalAmount;
  String get formattedTotalAmount => formatCurrency(_totalAmount);
  List<AdditionalServicesData> get additionalServices => _additionalServices;

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
      if (passenger.type == null || !['Adult', 'Child', 'Infant'].contains(passenger.type)) {
        debugPrint('Warning: Invalid or missing type for passenger at index $index');
      }
      final service = AdditionalServicesData(
        passengerName: passengerInfoViewModel.getFullName(index),
        passengerType: passenger.type ?? 'Unknown',
        passengerAge: passengerInfoViewModel.getAge(index).clamp(0, 150),
      );
      debugPrint(
          'Initialized AdditionalServicesData: ${service.passengerName}, ${service.passengerType}, Age: ${service.passengerAge}');
      return service;
    }).toList();
  }

  void updateBaggage(int index, String? baggage, double cost) {
    if (index >= 0 && index < _additionalServices.length) {
      _additionalServices[index].updateBaggage(baggage, cost);
      _updateTotal();
      notifyListeners();
    }
  }

  void updateMeal(int index, String? meal, double cost) {
    if (index >= 0 && index < _additionalServices.length) {
      _additionalServices[index].updateMeal(meal, cost);
      _updateTotal();
      notifyListeners();
    }
  }

  void toggleComprehensiveInsurance(bool value) {
    _comprehensiveInsurance = value;
    _updateTotal();
    notifyListeners();
  }

  void toggleFlightDelayInsurance(bool value) {
    _flightDelayInsurance = value;
    _updateTotal();
    notifyListeners();
  }

  void _updateTotal() {
    final passengerCount = (searchViewModel?.passengerAdults ?? 0) +
        (searchViewModel?.passengerChilds ?? 0) +
        (searchViewModel?.passengerInfants ?? 0);
    final baseFare = parsePrice(flightData?.price ?? '0');
    final additionalServicesCost = _additionalServices.fold(
      0.0,
          (sum, service) => sum + service.totalCost,
    );
    _totalAmount = baseFare +
        (_comprehensiveInsurance
            ? comprehensiveInsuranceCost * passengerCount
            : 0) +
        (_flightDelayInsurance ? flightDelayInsuranceCost * passengerCount : 0) +
        additionalServicesCost;
  }

  void addService(String service) {
    debugPrint("Added service: $service");
    notifyListeners();
  }

  void continueAction(BuildContext context) {
    debugPrint("Continue pressed with total: $_totalAmount VND");
    // TODO: Navigate to the next screen (e.g., PaymentScreen)
  }

  Future<void> showTicketDetailsSheet(BuildContext context) async {
    if (flightData == null) {
      debugPrint('Lỗi: Dữ liệu chuyến bay rỗng');
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
      final dayOfWeek =
      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][parsedDate.weekday - 1];
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
    final flightClass = searchViewModel?.seatClass ?? "Economy";
    return "$airline";
  }

  double parsePrice(String price) {
    try {
      String cleanedPrice = price.replaceAll('VND', '').trim();
      cleanedPrice = cleanedPrice.replaceAll('.', '');
      cleanedPrice = cleanedPrice.replaceAll(',', '.');
      return double.parse(cleanedPrice);
    } catch (e) {
      debugPrint('Lỗi phân tích giá: $e với đầu vào: $price');
      return double.infinity;
    }
  }

  String formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0);
    return formatted.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}