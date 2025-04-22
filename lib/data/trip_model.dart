import 'package:booking_flight/data/passenger_infor_model.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String id;
  final FlightData? flightData;
  final List<Passenger> passengers;
  final ContactInfo contactInfo;
  final List<Map<String, dynamic>> additionalServices;
  final double totalAmount;
  final Timestamp createdAt;

  Trip({
    required this.id,
    this.flightData,
    required this.passengers,
    required this.contactInfo,
    required this.additionalServices,
    required this.totalAmount,
    required this.createdAt,
  });

  factory Trip.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return Trip(
      id: doc.id,
      flightData: data?['flightData'] != null
          ? FlightData.fromJson(data!['flightData'] as Map<String, dynamic>)
          : null,
      passengers: (data?['passengers'] as List<dynamic>?)
          ?.map((e) => Passenger.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      contactInfo: data?['contactInfo'] != null
          ? ContactInfo.fromJson(data!['contactInfo'] as Map<String, dynamic>)
          : ContactInfo(email: null, phoneNumber: null), // Fallback
      additionalServices: (data?['additionalServices'] as List<dynamic>?)
          ?.map((e) => Map<String, dynamic>.from(e as Map))
          .toList() ??
          [],
      totalAmount: (data?['totalAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: data?['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'flightData': flightData?.toJson(),
      'passengers': passengers.map((p) => p.toJson()).toList(),
      'contactInfo': contactInfo.toJson(), // Added
      'additionalServices': additionalServices,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
    };
  }
}