import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceCalculator {
  static final currencyFormatter =
  NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

  double _parsePrice(String price) {
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
  double getBaseFareNumeric(String price) => _parsePrice(price);
  String calculateTotalPrice({
    required String basePrice,
    required int adults,
    required int children,
    required int infants,
  }) {
    final total = calculateTotalAmount(
      basePrice: basePrice,
      adults: adults,
      children: children,
      infants: infants,
    );
    return total > 0 ? '${currencyFormatter.format(total)} VND' : 'N/A';
  }

  double calculateTotalAmount({
    required String basePrice,
    required int adults,
    required int children,
    required int infants,
  }) {
    final baseFareNumeric = _parsePrice(basePrice);
    final adultAmount = baseFareNumeric * adults;
    final childAmount = (baseFareNumeric * 0.75) * children;
    final infantAmount = (baseFareNumeric * 0.10) * infants;
    return adultAmount + childAmount + infantAmount;
  }
}