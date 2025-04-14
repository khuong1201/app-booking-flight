import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_flight/core/widget/widgets.dart';
import 'package:booking_flight/presentation/view/home/round_trip_form_view.dart';
import 'package:booking_flight/presentation/view/home/one_way_trip_form_view.dart';
import 'flight_discount_view.dart';
import '../../viewmodel/home/booking_flight_view_model.dart';

class BookingFlightScreen extends StatelessWidget {
  const BookingFlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingFlightViewModel(),
      child: Consumer<BookingFlightViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: SingleChildScrollView(
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
                            onTap: viewModel.onTabTapped,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: IndexedStack(
                      index: viewModel.tabIndex,
                      children: const [RoundTripForm(), OneWayTripForm()],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: FlightDiscount(),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: CustomBottomNavigationBar(
                currentIndex: viewModel.bottomNavIndex,
                onTap: viewModel.onBottomNavTapped,
              ),
            ),
          );
        },
      ),
    );
  }
}
