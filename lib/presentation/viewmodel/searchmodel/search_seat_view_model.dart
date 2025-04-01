import 'package:flutter/material.dart';
import '../../../data/seat_class_data.dart';

class SeatSelectionViewModel extends ChangeNotifier {
  String selectedClass = 'Economy';

  List<SeatClass> get seatClasses => seatClassesData; // Use seatClassesData

  void updateSelectedClass(String newClass) {
    if (selectedClass != newClass) {
      selectedClass = newClass;
      notifyListeners();
    }
  }
}