import 'package:booking_flight/presentation/view/home/my_trip_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_flight/core/widget/widgets.dart';
import 'package:booking_flight/presentation/view/home/round_trip_form_view.dart';
import 'package:booking_flight/presentation/view/home/one_way_trip_form_view.dart';
import 'package:booking_flight/presentation/view/home/flight_discount_view.dart';
import 'package:booking_flight/presentation/viewmodel/home/booking_flight_view_model.dart';

class BookingFlightScreen extends StatelessWidget {
  const BookingFlightScreen({super.key});

  Widget _buildHomeContent(BuildContext context) {
    return Consumer<BookingFlightViewModel>(
      builder: (context, viewModel, child) {
        debugPrint('BookingFlightScreen home content rebuild với tabIndex: ${viewModel.tabIndex}');
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  const LogoWidget(imagePath: "assets/logo/Primiter.png"),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTabBar(
                        currentIndex: viewModel.tabIndex,
                        onTap: (index) => viewModel.onTabTapped(index),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: IndexedStack(
                  index: viewModel.tabIndex,
                  children: const [
                    RoundTripForm(),
                    OneWayTripForm(),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: FlightDiscount(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Consumer<BookingFlightViewModel>(
      builder: (context, viewModel, child) {
        debugPrint('BookingFlightScreen rebuild với bottomNavIndex: ${viewModel.bottomNavIndex}');
        return Scaffold(
          key: scaffoldKey,
          body: IndexedStack(
            index: viewModel.bottomNavIndex,
            children: [
              _buildHomeContent(context), // Nội dung BookingFlightScreen
              const MyTripScreen(),
              //const SettingsScreen(),
              //const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: CustomBottomNavigationBar(
              currentIndex: viewModel.bottomNavIndex,
              onTap: (index) => viewModel.onBottomNavTapped(index),
            ),
          ),
        );
      },
    );
  }
}