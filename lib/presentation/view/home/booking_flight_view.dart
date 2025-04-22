import 'package:booking_flight/core/widget/widgets.dart';
import 'package:booking_flight/data/contact_info_storage.dart';
import 'package:booking_flight/data/passenger_infor_model.dart';
import 'package:booking_flight/presentation/view/home/flight_discount_view.dart';
import 'package:booking_flight/presentation/view/home/my_trip_view.dart';
import 'package:booking_flight/presentation/view/home/one_way_trip_form_view.dart';
import 'package:booking_flight/presentation/view/home/round_trip_form_view.dart';
import 'package:booking_flight/presentation/viewmodel/home/booking_flight_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingFlightScreen extends StatelessWidget {
  const BookingFlightScreen({super.key});

  Widget _buildHomeContent(BuildContext context) {
    return Consumer<BookingFlightViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  const LogoWidget(imagePath: 'assets/logo/Primiter.png'),
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
        // Show errors from viewModel if any
        if (viewModel.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(viewModel.errorMessage)),
            );
            viewModel.clearError();
          });
        }
        return Scaffold(
          key: scaffoldKey,
          body: IndexedStack(
            index: viewModel.bottomNavIndex,
            children: [
              _buildHomeContent(context),
              MyTripScreen(contactId: viewModel.contactId ?? 'default_user'),
              const Center(child: Text('Settings - Coming Soon')),
              const Center(child: Text('Profile - Coming Soon')),
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