import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/search_flight_Data.dart';
import '../../../data/search_tickets_tmp_data.dart';

class DetailFlightTicketsViewModel extends ChangeNotifier {
  final SearchTicketsTemp searchTicketData;
  final FlightData? flightData;

  DetailFlightTicketsViewModel({
    required this.searchTicketData,
    this.flightData,
  });

  String get routeTitle =>
      "${searchTicketData.departureAirportCode ?? 'N/A'} - ${searchTicketData.arrivalAirportCode ?? 'N/A'}";

  String get airlineName => flightData?.airlineName ?? "Unknown Airline";
  String get airlineLogo =>
      flightData?.airlineLogo ?? 'assets/icons/Airplane.png';
  String get flightCode => flightData != null
      ? "${flightData!.airlineName} | ${flightData!.departureAirport}"
      : "Unknown Flight";

  String get departureAirport =>
      searchTicketData.departureAirportCode ?? "Unknown";
  String get departureTime => flightData?.departureTime ?? "N/A";
  String get departureDate =>
      flightData?.departureDate ?? searchTicketData.departingDate ?? "Unknown Date";
  String get arrivalAirport =>
      searchTicketData.arrivalAirportCode ?? "Unknown";
  String get arrivalTime => flightData?.arrivalTime ?? "N/A";
  String get arrivalDate =>
      flightData?.departureDate ?? searchTicketData.departingDate ?? "Unknown Date";
  String get flightDuration => flightData?.duration ?? "N/A";
  String get flightType =>
      searchTicketData.isRoundTrip ? "Round Trip" : "One Way";

  String get checkedBaggage =>
      searchTicketData.seatClass == "Economy" ? "Not Included" : "Included";
  String get carryOnBaggage => "Maximum 1 piece, up to 7kg";

  final List<String> flightChanges = const [
    "• Change Fee: 750.000 VND (domestic), 800.000 VND (international)",
    "• Fare Difference applies",
    "• Advance Notice: At least 3 hours before departure time",
  ];

  final List<String> ticketUpgrade = const [
    "• Change Fee applies",
    "• Fare Difference applies",
  ];

  String get refundPolicy => "Allowed with a fee (conditions apply)";
  String get noShowPolicy => "Non-refundable / Loss of fare";
  String get passengerNameChange => "Not applicable / Not permitted";

  double get _baseFareNumeric {
    if (flightData == null || flightData!.price.isEmpty) {
      return 0.0;
    }
    final priceString = flightData!.price.replaceAll(RegExp(r'[^\d]'), '');
    final parsedValue = double.tryParse(priceString);
    return parsedValue ?? 0.0;
  }

  final currencyFormatter =
  NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

  String get adultFareString {
    if (flightData == null || flightData!.price.isEmpty) return "N/A";
    final priceNumeric = int.tryParse(
        flightData!.price.replaceAll('.', '').replaceAll(RegExp(r'[^\d]'), ''));
    return priceNumeric != null
        ? "${currencyFormatter.format(priceNumeric)} VND"
        : "N/A";
  }

  String get childFareString {
    return flightData != null
        ? "${currencyFormatter.format(_baseFareNumeric * 0.75)} VND"
        : "N/A";
  }

  String get infantFareString {
    return flightData != null
        ? "${currencyFormatter.format(_baseFareNumeric * 0.10)} VND"
        : "N/A";
  }

  double calculateTotalAmount() {
    if (flightData == null) return 0.0;
    final adults = searchTicketData.passengerAdults ?? 0;
    final children = searchTicketData.passengerChilds ?? 0;
    final infants = searchTicketData.passengerInfants ?? 0;
    final adultAmount = _baseFareNumeric * adults;
    final childAmount = (_baseFareNumeric * 0.75) * children;
    final infantAmount = (_baseFareNumeric * 0.10) * infants;
    return adultAmount + childAmount + infantAmount;
  }

  String get totalAmountString =>
      "${currencyFormatter.format(calculateTotalAmount())} VND";
  int get passengerAdults => searchTicketData.passengerAdults ;
  int get passengerChilds => searchTicketData.passengerChilds ;
  int get passengerInfants => searchTicketData.passengerInfants ;
}