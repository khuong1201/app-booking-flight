import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/search_flight_data.dart';
import '../../../data/SearchViewModel.dart';

class DetailFlightTicketsViewModel extends ChangeNotifier {
  final FlightData? flightData;
  final SearchViewModel? searchViewModel;

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
  String get flightCode => flightData?.flightCode ?? 'N/A'; // Giả định flightCode có thể không tồn tại

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
  double get _baseFareNumeric => _parsePrice(flightData?.price ?? '');

  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

  String get adultFareString {
    if (_baseFareNumeric == 0.0) return 'N/A';
    return '${currencyFormatter.format(_baseFareNumeric)} VND';
  }

  String get childFareString {
    if (_baseFareNumeric == 0.0) return 'N/A';
    return '${currencyFormatter.format(_baseFareNumeric * 0.75)} VND';
  }

  String get infantFareString {
    if (_baseFareNumeric == 0.0) return 'N/A';
    return '${currencyFormatter.format(_baseFareNumeric * 0.10)} VND';
  }

  double calculateTotalAmount() {
    final adults = passengerAdults;
    final children = passengerChilds;
    final infants = passengerInfants;
    final adultAmount = _baseFareNumeric * adults;
    final childAmount = (_baseFareNumeric * 0.75) * children;
    final infantAmount = (_baseFareNumeric * 0.10) * infants;
    return adultAmount + childAmount + infantAmount;
  }

  String get totalAmountString {
    final total = calculateTotalAmount();
    return total > 0 ? '${currencyFormatter.format(total)} VND' : 'N/A';
  }

  // --- Passenger Information ---
  int get passengerAdults => searchViewModel?.passengerAdults ?? 0;
  int get passengerChilds => searchViewModel?.passengerChilds ?? 0;
  int get passengerInfants => searchViewModel?.passengerInfants ?? 0;

  // --- Utility Methods ---
  String? _extractCode(Map<String, dynamic>? airport) {
    return airport?['code'];
  }

  static double _parsePrice(String price) {
    try {
      // Loại bỏ đơn vị tiền tệ và khoảng trắng
      String cleanedPrice = price.replaceAll('VND', '').trim();

      // Thay dấu chấm (phân cách hàng nghìn) thành rỗng
      cleanedPrice = cleanedPrice.replaceAll('.', '');

      // Thay dấu phẩy (phân cách thập phân) thành dấu chấm
      cleanedPrice = cleanedPrice.replaceAll(',', '.');

      // Phân tích thành double
      return double.parse(cleanedPrice);
    } catch (e) {
      debugPrint('Lỗi phân tích giá: $e với đầu vào: $price');
      return 0.0; // Giữ nguyên 0.0 như mã gốc
    }
  }
}