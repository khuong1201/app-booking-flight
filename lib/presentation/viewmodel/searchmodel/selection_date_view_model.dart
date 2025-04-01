import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectionDateViewModel extends ChangeNotifier {
  DateTime? departingDate;
  DateTime? returningDate;
  List<DateTime> months = [];

  SelectionDateViewModel() {
    generateMonths();
  }

  void generateMonths() {
    DateTime currentMonth = DateTime.now();
    months = List.generate(
      12 * 3 - currentMonth.month + 1,
          (index) {
        int month = currentMonth.month + index;
        int yearOffset = month > 12 ? 1 : 0;
        int monthInYear = month > 12 ? month - 12 : month;
        int year = currentMonth.year + (index + currentMonth.month - 1) ~/ 12;
        return DateTime(year, monthInYear);
      },
    );
    notifyListeners();
  }

  void onDateSelected(DateTime date) {
    if (departingDate != null && departingDate!.isAtSameMomentAs(date)) {
      departingDate = null;
    } else if (returningDate != null && returningDate!.isAtSameMomentAs(date)) {
      returningDate = null;
    } else {
      if (departingDate == null) {
        departingDate = date;
      } else if (returningDate == null && date.isAfter(departingDate!)) {
        returningDate = date;
      } else {
        departingDate = date;
        returningDate = null;
      }
    }
    notifyListeners();
  }

  void updateDepartingDate(String date) {
    try {
      departingDate = DateFormat('EEE, MMM d yyyy').parse(date);
      returningDate = null;
    } catch (e) {
      print('Error parsing departing date: $e');
    }
    notifyListeners();
  }

  void updateReturningDate(String date) {
    try {
      returningDate = DateFormat('EEE, MMM d yyyy').parse(date);
    } catch (e) {
      print('Error parsing returning date: $e');
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