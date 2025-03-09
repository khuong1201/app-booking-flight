import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';

class BookingFlightScreen extends StatefulWidget {
  const BookingFlightScreen({super.key});

  @override
  State<BookingFlightScreen> createState() => _BookingFlightScreenState();
}

class _BookingFlightScreenState extends State<BookingFlightScreen> {
  int _selectedTab = 0; // 0: Round Trip, 1: One-way Trip

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Phần Logo
          Container(
            width: double.infinity,
            height: 246,
            color: AppColors.primaryColor,
            child: Center(
              child: Image.asset(
                'assets/logo/Primiter.png',
                height: 246,
                width: 411,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
