import 'airport_data.dart';

class FlightData {
  final String airlineName;
  final String airlineLogo;
  final String departureTime;
  final String arrivalTime;
  final String departureDate;
  final String arrivalDate;
  final String duration;
  final String price;
  final String flightCode;
  final String departureAirport;
  final String arrivalAirport;
  final String passengerCount;
  final String? returnDate;
  final String? returnDepartureTime;
  final String? returnArrivalTime;

  FlightData({
    required this.airlineName,
    required this.airlineLogo,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureDate,
    required this.arrivalDate,
    required this.duration,
    required this.price,
    required this.flightCode,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.passengerCount,
    this.returnDate,
    this.returnDepartureTime,
    this.returnArrivalTime,
  });
}
String getAirportName(String airportCode) {
  final airport = airports.firstWhere(
        (airport) => airport['code'] == airportCode,
    orElse: () => {"name": "Unknown Airport"},
  );
  return airport['name']!;
}
String getAirportCity(String airportCode) {
  final airport = airports.firstWhere(
        (airport) => airport['code'] == airportCode,
    orElse: () => {"city": "Unknown City"},
  );
  return airport['city']!;
}
// Lấy danh sách sân bay theo loại
List<Map<String, String>> getAirportsByType(String type) {
  return airports.where((airport) => airport['type'] == type).toList();
}

// Lấy danh sách sân bay theo thành phố
List<Map<String, String>> getAirportsByCity(String city) {
  return airports.where((airport) => airport['city'] == city).toList();
}
// Danh sách chuyến bay mở rộng từ 22/04 đến 30/04
final List<FlightData> flightDataList = [
  // --- Existing flights ---
  FlightData(
    airlineLogo: 'assets/logo/Bamboo-Airways-V.png',
    airlineName: 'Bamboo Airways',
    departureTime: '06:30',
    arrivalTime: '08:35',
    duration: '2h 5m',
    departureDate: '2025-04-22',
    arrivalDate: '2025-04-22',
    price: '2.500.000 VND',
    flightCode: 'BA234',
    departureAirport: 'SGN',
    arrivalAirport: 'HAN',
    passengerCount: '1 passenger',
  ),
  FlightData(
    airlineLogo: 'assets/logo/vietjet.png',
    airlineName: 'VietJet Air',
    departureTime: '09:30',
    arrivalTime: '11:35',
    duration: '2h 5m',
    departureDate: '2025-04-22',
    arrivalDate: '2025-04-22',
    price: '2.150.000 VND',
    flightCode: 'VJ345',
    departureAirport: 'SGN',
    arrivalAirport: 'HAN',
    passengerCount: '1 passenger',
  ),
  FlightData(
    airlineLogo: 'assets/logo/Bamboo-Airways-V.png',
    airlineName: 'Bamboo Airways',
    departureTime: '15:30',
    arrivalTime: '17:35',
    duration: '1h 45m',
    departureDate: '2025-04-22',
    arrivalDate: '2025-04-22',
    price: '2.500.000 VND',
    flightCode: 'BA250',
    departureAirport: 'SGN',
    arrivalAirport: 'VDO',
    passengerCount: '1 passenger',
  ),

  // --- One-way ---
  FlightData(
    airlineLogo: 'assets/logo/vn airlines.png',
    airlineName: 'Vietnam Airlines',
    departureTime: '07:15',
    arrivalTime: '09:30',
    duration: '2h 15m',
    departureDate: '2025-04-24',
    arrivalDate: '2025-04-24',
    price: '2.700.000 VND',
    flightCode: 'VN123',
    departureAirport: 'SGN',
    arrivalAirport: 'DAD',
    passengerCount: '1 passenger',
  ),
  FlightData(
    airlineLogo: 'assets/logo/vietjet.png',
    airlineName: 'VietJet Air',
    departureTime: '10:00',
    arrivalTime: '12:00',
    duration: '2h 0m',
    departureDate: '2025-04-25',
    arrivalDate: '2025-04-25',
    price: '2.000.000 VND',
    flightCode: 'VJ678',
    departureAirport: 'HAN',
    arrivalAirport: 'SGN',
    passengerCount: '1 passenger',
  ),

  // --- Round-trip ---
  FlightData(
    airlineLogo: 'assets/logo/Bamboo-Airways-V.png',
    airlineName: 'Bamboo Airways',
    departureTime: '08:00',
    arrivalTime: '10:10',
    duration: '2h 10m',
    departureDate: '2025-04-26',
    arrivalDate: '2025-04-26',
    returnDate: '2025-04-29',
    returnDepartureTime: '18:30',
    returnArrivalTime: '20:45',
    price: '4.800.000 VND',
    flightCode: 'BA789',
    departureAirport: 'SGN',
    arrivalAirport: 'CXR',
    passengerCount: '2 passengers',
  ),
  FlightData(
    airlineLogo: 'assets/logo/vn airlines.png',
    airlineName: 'Vietnam Airlines',
    departureTime: '13:00',
    arrivalTime: '15:00',
    duration: '2h 0m',
    departureDate: '2025-04-27',
    arrivalDate: '2025-04-27',
    returnDate: '2025-04-30',
    returnDepartureTime: '10:00',
    returnArrivalTime: '12:00',
    price: '5.200.000 VND',
    flightCode: 'VN456',
    departureAirport: 'HAN',
    arrivalAirport: 'DIN',
    passengerCount: '1 passenger',
  ),
  FlightData(
    airlineLogo: 'assets/logo/vietjet.png',
    airlineName: 'VietJet Air',
    departureTime: '19:20',
    arrivalTime: '21:25',
    duration: '2h 5m',
    departureDate: '2025-04-28',
    arrivalDate: '2025-04-28',
    returnDate: '2025-04-30',
    returnDepartureTime: '14:00',
    returnArrivalTime: '16:05',
    price: '4.300.000 VND',
    flightCode: 'VJ999',
    departureAirport: 'SGN',
    arrivalAirport: 'HPH',
    passengerCount: '1 passenger',
  ),
];

