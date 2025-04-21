
abstract class SearchViewModel {
  Map<String, dynamic>? get departureAirport;
  Map<String, dynamic>? get arrivalAirport;
  DateTime? get departureDate;
  DateTime? get returnDate;
  int get passengerAdults;
  int get passengerChilds;
  int get passengerInfants;
  String get seatClass;
}
