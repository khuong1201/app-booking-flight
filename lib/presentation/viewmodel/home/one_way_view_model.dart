import 'package:flutter/material.dart';

class OneWayTripViewModel extends ChangeNotifier {
  Map<String, String>? departureAirport;
  Map<String, String>? arrivalAirport;
  DateTime? departureDate;
  int passengers = 1;
  String seatClass = "Economy";

  // Cập nhật sân bay đi
  void setDepartureAirport(Map<String, String> airport) {
    departureAirport = airport;
    notifyListeners();
  }

  // Cập nhật sân bay đến
  void setArrivalAirport(Map<String, String> airport) {
    arrivalAirport = airport;
    notifyListeners();
  }

  // Cập nhật ngày khởi hành
  void setDepartureDate(DateTime date) {
    departureDate = date;
    notifyListeners();
  }

  // Cập nhật số hành khách
  void setPassengers(int count) {
    passengers = count;
    notifyListeners();
  }

  // Cập nhật hạng ghế
  void setSeatClass(String seat) {
    seatClass = seat;
    notifyListeners();
  }

  // Tìm chuyến bay (Logic tìm kiếm có thể được thêm vào sau)
  void searchFlights() {
    // Thêm logic tìm kiếm chuyến bay tại đây.
  }
}
