class FlightData {
  final String airlineLogo;
  final String airlineName;
  final String departureTime;
  final String departureAirport;
  final String arrivalTime;
  final String arrivalAirport;
  final String price;
  final String passengerCount;
  final String duration;
  final String departureDate;

  FlightData({
    required this.airlineLogo,
    required this.airlineName,
    required this.departureTime,
    required this.departureAirport,
    required this.arrivalTime,
    required this.arrivalAirport,
    required this.price,
    required this.passengerCount,
    required this.duration,
    required this.departureDate,
  });
}

final List<FlightData> flightDataList = [
  // Existing flights
  FlightData(
    airlineLogo: 'assets/logo/Bamboo-Airways-V.png',
    airlineName: 'Bamboo Airways',
    departureTime: '05:30',
    departureAirport: 'SGN',
    arrivalTime: '07:35',
    arrivalAirport: 'HAN',
    price: '1.571.063 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-12',
  ),
  FlightData(
    airlineLogo: 'assets/logo/vn airlines.png',
    airlineName: 'Vietnam Airlines',
    departureTime: '07:30',
    departureAirport: 'SGN',
    arrivalTime: '09:35',
    arrivalAirport: 'HAN',
    price: '1.771.560 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-12',
  ),
  FlightData(
    airlineLogo: 'assets/logo/Vietravel-Airlines.png',
    airlineName: 'Vietravel Airlines',
    departureTime: '10:00',
    departureAirport: 'SGN',
    arrivalTime: '12:05',
    arrivalAirport: 'HAN',
    price: '1.771.560 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-12',
  ),

  // New flights
  FlightData(
    airlineLogo: 'assets/logo/Bamboo-Airways-V.png',
    airlineName: 'Bamboo Airways',
    departureTime: '06:30',
    departureAirport: 'SGN',
    arrivalTime: '08:35',
    arrivalAirport: 'HAN',
    price: '1.650.000 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-13',
  ),
  FlightData(
    airlineLogo: 'assets/logo/VietJet-Air.png',
    airlineName: 'VietJet Air',
    departureTime: '08:30',
    departureAirport: 'SGN',
    arrivalTime: '10:35',
    arrivalAirport: 'HAN',
    price: '2.000.000 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-13',
  ),
  FlightData(
    airlineLogo: 'assets/logo/Vietravel-Airlines.png',
    airlineName: 'Vietravel Airlines',
    departureTime: '11:00',
    departureAirport: 'SGN',
    arrivalTime: '13:05',
    arrivalAirport: 'HAN',
    price: '1.950.000 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-13',
  ),
  FlightData(
    airlineLogo: 'assets/logo/vn airlines.png',
    airlineName: 'Vietnam Airlines',
    departureTime: '14:00',
    departureAirport: 'SGN',
    arrivalTime: '16:05',
    arrivalAirport: 'HAN',
    price: '2.200.000 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-13',
  ),
  FlightData(
    airlineLogo: 'assets/logo/VietJet-Air.png',
    airlineName: 'VietJet Air',
    departureTime: '16:30',
    departureAirport: 'SGN',
    arrivalTime: '18:35',
    arrivalAirport: 'HAN',
    price: '2.150.000 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-14',
  ),
  FlightData(
    airlineLogo: 'assets/logo/Bamboo-Airways-V.png',
    airlineName: 'Bamboo Airways',
    departureTime: '18:00',
    departureAirport: 'SGN',
    arrivalTime: '20:05',
    arrivalAirport: 'HAN',
    price: '2.100.000 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-14',
  ),
  FlightData(
    airlineLogo: 'assets/logo/VietJet-Air.png',
    airlineName: 'VietJet Air',
    departureTime: '20:30',
    departureAirport: 'SGN',
    arrivalTime: '22:35',
    arrivalAirport: 'HAN',
    price: '2.350.000 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-15',
  ),
  FlightData(
    airlineLogo: 'assets/logo/VietJet-Air.png',
    airlineName: 'VietJet Air',
    departureTime: '09:00',
    departureAirport: 'SGN',
    arrivalTime: '11:05',
    arrivalAirport: 'HAN',
    price: '2.300.000 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-15',
  ),
  FlightData(
    airlineLogo: 'assets/logo/Bamboo-Airways-V.png',
    airlineName: 'Bamboo Airways',
    departureTime: '11:30',
    departureAirport: 'SGN',
    arrivalTime: '13:35',
    arrivalAirport: 'HAN',
    price: '2.250.000 VND',
    passengerCount: '1 passenger',
    duration: '2h 5m',
    departureDate: '2025-04-15',
  ),

  // Additional flights with different airports
  FlightData(
    airlineLogo: 'assets/logo/vn airlines.png',
    airlineName: 'Vietnam Airlines',
    departureTime: '12:00',
    departureAirport: 'DAD',
    arrivalTime: '13:30',
    arrivalAirport: 'CKR',
    price: '1.800.000 VND',
    passengerCount: '1 passenger',
    duration: '1h 30m',
    departureDate: '2025-04-16',
  ),
  FlightData(
    airlineLogo: 'assets/logo/VietJet-Air.png',
    airlineName: 'VietJet Air',
    departureTime: '15:00',
    departureAirport: 'PQC',
    arrivalTime: '16:45',
    arrivalAirport: 'SGN',
    price: '2.100.000 VND',
    passengerCount: '1 passenger',
    duration: '1h 45m',
    departureDate: '2025-04-17',
  ),
  FlightData(
    airlineLogo: 'assets/logo/Bamboo-Airways-V.png',
    airlineName: 'Bamboo Airways',
    departureTime: '17:30',
    departureAirport: 'HAN',
    arrivalTime: '19:15',
    arrivalAirport: 'VDO',
    price: '2.500.000 VND',
    passengerCount: '1 passenger',
    duration: '1h 45m',
    departureDate: '2025-04-18',
  ),
  FlightData(
    airlineLogo: 'assets/logo/Vietravel-Airlines.png',
    airlineName: 'Vietravel Airlines',
    departureTime: '10:30',
    departureAirport: 'UIH',
    arrivalTime: '12:00',
    arrivalAirport: 'SGN',
    price: '2.050.000 VND',
    passengerCount: '1 passenger',
    duration: '1h 30m',
    departureDate: '2025-04-19',
  ),
  FlightData(
    airlineLogo: 'assets/logo/vn airlines.png',
    airlineName: 'Vietnam Airlines',
    departureTime: '14:30',
    departureAirport: 'BMV',
    arrivalTime: '15:45',
    arrivalAirport: 'SGN',
    price: '1.900.000 VND',
    passengerCount: '1 passenger',
    duration: '1h 15m',
    departureDate: '2025-04-20',
  ),
];
