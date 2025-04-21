import 'package:flutter/material.dart';
import '../../../data/seat_class_model.dart';

class SeatSelectionViewModel extends ChangeNotifier {
  String selectedClass = 'Economy';

  List<SeatClass> get seatClasses => seatClassesData;

  void updateSelectedClass(String newClass) {
    if (selectedClass != newClass) {
      selectedClass = newClass;
      notifyListeners();
    }
  }
}