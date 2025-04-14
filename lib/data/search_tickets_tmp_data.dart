class SearchTicketsTemp {
  final String? departingDate;
  final String? returningDate;
  final int passengerAdults;
  final int passengerChilds;
  final int passengerInfant;
  final String? departureAirportCode;
  final String? arrivalAirportCode;
  final String seatClass;
  final bool isRoundTrip;

  SearchTicketsTemp({
    required this.departingDate,
    required this.returningDate,
    required this.passengerAdults,
    required this.passengerChilds,
    required this.passengerInfant,
    required this.departureAirportCode,
    required this.arrivalAirportCode,
    required this.seatClass,
    required this.isRoundTrip,
  });
}