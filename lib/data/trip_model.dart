import 'package:booking_flight/data/passenger_infor_model.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String id;
  final FlightData? flightData; // Changed to FlightData? from Map<String, dynamic>?
  final List<Passenger> passengers;
  final List<Map<String, dynamic>> additionalServices;
  final double totalAmount;
  final Timestamp createdAt;

  Trip({
    required this.id,
    required this.flightData,
    required this.passengers,
    required this.additionalServices,
    required this.totalAmount,
    required this.createdAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String? ?? '', // Handle null ID with default
      flightData: json['flightData'] != null
          ? FlightData.fromJson(json['flightData'] as Map<String, dynamic>)
          : null, // Parse FlightData or set null
      passengers: (json['passengers'] as List<dynamic>?)
          ?.map((e) => Passenger.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [], // Handle null passengers
      additionalServices: (json['additionalServices'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
          [], // Handle null services
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0, // Handle null amount
      createdAt: json['createdAt'] as Timestamp? ??
          Timestamp.now(), // Default to now if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flightData': flightData?.toJson(), // Convert FlightData to JSON
      'passengers': passengers.map((p) => p.toJson()).toList(),
      'additionalServices': additionalServices,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
    };
  }
}