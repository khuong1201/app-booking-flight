import 'package:booking_flight/core/utils/caculator_price_total_passenger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/search_flight_data.dart';

class DetailFlightTicketsViewModel extends ChangeNotifier {
  final FlightData? flightData;
  final dynamic searchViewModel;
  final PriceCalculator _pricingService = PriceCalculator(); // Thêm PriceCalculator

  DetailFlightTicketsViewModel({
    required this.flightData,
    required this.searchViewModel,
  });

  // --- Flight Information ---
  String get routeTitle {
    final departureCode = _extractCode(searchViewModel?.departureAirport) ?? flightData?.departureAirport ?? 'Unknown';
    final arrivalCode = _extractCode(searchViewModel?.arrivalAirport) ?? flightData?.arrivalAirport ?? 'Unknown';
    return '$departureCode - $arrivalCode';
  }

  String get airlineName => flightData?.airlineName ?? 'Unknown';
  String get airlineLogo => flightData?.airlineLogo ?? '';
  String get flightCode => flightData?.flightCode ?? 'N/A';

  String get departureAirport => _extractCode(searchViewModel?.departureAirport) ?? flightData?.departureAirport ?? 'Unknown';
  String get departureTime => flightData?.departureTime ?? 'N/A';
  String get departureDate => flightData?.departureDate ?? 'N/A';

  String get arrivalAirport => _extractCode(searchViewModel?.arrivalAirport) ?? flightData?.arrivalAirport ?? 'Unknown';
  String get arrivalTime => flightData?.arrivalTime ?? 'N/A';
  String get arrivalDate => flightData?.arrivalDate ?? 'N/A';

  String get flightDuration => flightData?.duration ?? 'N/A';
  String get flightType {
    return searchViewModel?.returnDate != null ? 'Round Trip' : 'One Way';
  }

  String get returnDate {
    if (flightData?.returnDate != null) {
      return flightData!.returnDate!;
    }
    if (searchViewModel?.returnDate != null) {
      return DateFormat('yyyy-MM-dd').format(searchViewModel!.returnDate!);
    }
    return 'N/A';
  }

  String get returnDepartureTime => flightData?.returnDepartureTime ?? 'N/A';
  String get returnArrivalTime => flightData?.returnArrivalTime ?? 'N/A';

  // --- Baggage and Policies ---
  String get checkedBaggage => searchViewModel?.seatClass == 'Economy' ? 'Not Included' : 'Included';
  String get carryOnBaggage => 'Maximum 1 piece, up to 7kg';

  static const List<String> flightChanges = [
    '• Change Fee: 750.000 VND (domestic), 800.000 VND (international)',
    '• Fare Difference applies',
    '• Advance Notice: At least 3 hours before departure time',
  ];

  static const List<String> ticketUpgrade = [
    '• Change Fee applies',
    '• Fare Difference applies',
  ];

  String get refundPolicy => 'Allowed with a fee (conditions apply)';
  String get noShowPolicy => 'Non-refundable / Loss of fare';
  String get passengerNameChange => 'Not applicable / Not permitted';

  // --- Price Calculations ---
  String get totalPrice => _pricingService.calculateTotalPrice(
    basePrice: flightData?.price ?? '',
    adults: passengerAdults,
    children: passengerChilds,
    infants: passengerInfants,
  );

  String get price => flightData?.price ?? 'N/A';

  String get adultFareString {
    final baseFareNumeric = _pricingService.getBaseFareNumeric(flightData?.price ?? '');
    if (baseFareNumeric == 0.0) return 'N/A';
    return '${PriceCalculator.currencyFormatter.format(baseFareNumeric)} VND';
  }

  String get childFareString {
    final baseFareNumeric = _pricingService.getBaseFareNumeric(flightData?.price ?? '');
    if (baseFareNumeric == 0.0) return 'N/A';
    return '${PriceCalculator.currencyFormatter.format(baseFareNumeric * 0.75)} VND';
  }

  String get infantFareString {
    final baseFareNumeric = _pricingService.getBaseFareNumeric(flightData?.price ?? '');
    if (baseFareNumeric == 0.0) return 'N/A';
    return '${PriceCalculator.currencyFormatter.format(baseFareNumeric * 0.10)} VND';
  }

  // --- Passenger Information ---
  int get passengerAdults => searchViewModel?.passengerAdults ?? 0;
  int get passengerChilds => searchViewModel?.passengerChilds ?? 0;
  int get passengerInfants => searchViewModel?.passengerInfants ?? 0;

  // --- Utility Methods ---
  String? _extractCode(Map<String, dynamic>? airport) {
    return airport?['code'];
  }
}