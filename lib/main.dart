import 'package:booking_flight/presentation/viewmodel/home/booking_flight_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/home/one_way_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/home/round_trip_view_model.dart';
import 'package:flutter/material.dart';
import 'package:booking_flight/presentation/view/welcome_view/welcome_view.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => OneWayTripViewModel()),
      ChangeNotifierProvider(create: (_) => RoundTripFormViewModel()),
      ChangeNotifierProvider(create: (_) => BookingFlightViewModel()),
    ],
    child: const MyApp(),
  ),);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
