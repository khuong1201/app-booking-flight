import 'package:flutter/material.dart';
import 'package:booking_flight/presentation/view/welcome/welcome_screen.dart';
import 'package:booking_flight/presentation/view/home/booking_flight_screen.dart';
import 'package:booking_flight/core/constants/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouters.welcomeScreen, // Route khởi chạy
      routes: {
        AppRouters.welcomeScreen: (context) => const WelcomeScreen(),
        AppRouters.bookingFlight: (context) => const BookingFlightScreen(),
      },
    );
  }
}
