import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectionDateViewModel extends ChangeNotifier {
  DateTime? departingDate;
  DateTime? returningDate;
  List<DateTime> months = [];
  bool isRoundTrip = false;

  SelectionDateViewModel({this.isRoundTrip = false}) {
    generateMonths();
  }

  void generateMonths() {
    DateTime currentMonth = DateTime.now();
    months = List.generate(
      12,
          (index) => DateTime(currentMonth.year, currentMonth.month + index),
    );
    notifyListeners();
  }

  void onDateSelected(DateTime date) {
    if (isRoundTrip) {
      if (departingDate == null) {
        // Nếu chưa chọn ngày đi, chọn ngày đi
        departingDate = date;
      } else if (returningDate == null && date.isAfter(departingDate!)) {
        // Nếu chưa chọn ngày về và ngày chọn sau ngày đi, chọn ngày về
        returningDate = date;
      } else if (returningDate != null && date.isBefore(returningDate!)) {
        // Nếu đã có ngày về và ngày chọn trước ngày về, chọn lại ngày về
        returningDate = date;
      } else if (departingDate == date || date.isBefore(departingDate!)) {
        // Nếu ngày chọn trùng với ngày đi hoặc là ngày trước ngày đi, cập nhật lại ngày đi
        departingDate = date;
        returningDate = null;  // Reset ngày về nếu có
      } else {
        // Nếu ngày chọn không hợp lệ, chọn lại ngày đi và bỏ chọn ngày về
        departingDate = date;
        returningDate = null;
      }
    } else {
      // Đối với chuyến đi một chiều, chỉ cần chọn ngày đi
      if (departingDate == date) {
        departingDate = null; // Bỏ chọn nếu đã chọn
      } else {
        departingDate = date;
      }
      returningDate = null;
    }

    notifyListeners(); // Cập nhật và thông báo cho UI
  }

  void updateDepartingDate(String date) {
    _updateDate(date, isDeparting: true);
  }

  void updateReturningDate(String date) {
    _updateDate(date, isDeparting: false);
  }

  void _updateDate(String date, {required bool isDeparting}) {
    try {
      DateTime newDate = DateFormat('EEE, MMM d yyyy').parse(date);
      if (isDeparting) {
        departingDate = newDate;
        returningDate = null;
      } else {
        returningDate = newDate;
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    notifyListeners();
  }

  void setRoundTrip(bool value) {
    isRoundTrip = value;
    if (!isRoundTrip) {
      returningDate = null;
    }
    notifyListeners();
  }

  Map<String, DateTime?> getSelectedDates() {
    return {
      'departingDate': departingDate,
      'returningDate': returningDate,
    };
  }
}