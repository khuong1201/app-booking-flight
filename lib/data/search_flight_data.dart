import 'package:booking_flight/data/airport_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlightData {
  final String id;
  final String airlineName;
  final String airlineLogo;
  final String departureTime;
  final String arrivalTime;
  final String departureDate;
  final String? arrivalDate;
  final String duration;
  final String price;
  final String? flightCode;
  final String departureAirport;
  final String arrivalAirport;
  final String? passengerCount;
  final String? returnDate;
  final String? returnDepartureTime;
  final String? returnArrivalTime;

  FlightData({
    required this.id,
    required this.airlineName,
    required this.airlineLogo,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureDate,
    this.arrivalDate,
    required this.duration,
    required this.price,
    this.flightCode,
    required this.departureAirport,
    required this.arrivalAirport,
    this.passengerCount,
    this.returnDate,
    this.returnDepartureTime,
    this.returnArrivalTime,
  });

  factory FlightData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FlightData(
      id: doc.id,
      airlineName: data['airlineName'] ?? '',
      airlineLogo: data['airlineLogo'] ?? '',
      departureTime: data['departureTime'] ?? '',
      departureAirport: data['departureAirport'] ?? '',
      arrivalTime: data['arrivalTime'] ?? '',
      arrivalAirport: data['arrivalAirport'] ?? '',
      duration: data['duration'] ?? '',
      price: data['price'] ?? '',
      departureDate: data['departureDate'] ?? '',
      arrivalDate: data['returnDate'] ?? data['departureDate'],
      flightCode: data['flightCode'] ?? '',
      passengerCount: data['passengerCount'] ?? null,
      returnDate: data['returnDate'],
      returnDepartureTime: data['returnDepartureTime'],
      returnArrivalTime: data['returnArrivalTime'],
    );
  }

  factory FlightData.fromJson(Map<String, dynamic> json) {
    return FlightData(
      id: json['id'] as String? ?? '',
      airlineName: json['airlineName'] as String? ?? '',
      airlineLogo: json['airlineLogo'] as String? ?? '',
      departureTime: json['departureTime'] as String? ?? '',
      departureAirport: json['departureAirport'] as String? ?? '',
      arrivalTime: json['arrivalTime'] as String? ?? '',
      arrivalAirport: json['arrivalAirport'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      price: json['price'] as String? ?? '',
      departureDate: json['departureDate'] as String? ?? '',
      arrivalDate: json['arrivalDate'] as String?,
      flightCode: json['flightCode'] as String?,
      passengerCount: json['passengerCount'] as String?,
      returnDate: json['returnDate'] as String?,
      returnDepartureTime: json['returnDepartureTime'] as String?,
      returnArrivalTime: json['returnArrivalTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airlineName': airlineName,
      'airlineLogo': airlineLogo,
      'departureTime': departureTime,
      'departureAirport': departureAirport,
      'arrivalTime': arrivalTime,
      'arrivalAirport': arrivalAirport,
      'duration': duration,
      'price': price,
      'departureDate': departureDate,
      'arrivalDate': arrivalDate,
      'flightCode': flightCode,
      'passengerCount': passengerCount,
      'returnDate': returnDate,
      'returnDepartureTime': returnDepartureTime,
      'returnArrivalTime': returnArrivalTime,
    };
  }
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

List<Map<String, String>> getAirportsByType(String type) {
  return airports.where((airport) => airport['type'] == type).toList();
}

List<Map<String, String>> getAirportsByCity(String city) {
  return airports.where((airport) => airport['city'] == city).toList();
}