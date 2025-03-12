import 'package:flutter/material.dart';
import 'package:booking_flight/core/widget/widgets.dart';
import 'package:booking_flight/presentation/view/home/round_trip_form.dart';
import 'package:booking_flight/presentation/view/home/one_way_trip_form.dart';
import 'flight_discount.dart';

class BookingFlightScreen extends StatefulWidget {
  const BookingFlightScreen({super.key});

  @override
  BookingFlightScreenState createState() => BookingFlightScreenState();
}

class BookingFlightScreenState extends State<BookingFlightScreen> {
  int tabIndex = 0;
  int bottomNavIndex = 0;
  void onTabTappedTabBar(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  void onItemTappedBottomNav(int index) {
    setState(() {
      bottomNavIndex = index;
    });
    if (index == 0) {
      setState(() {
        tabIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    child: LogoWidget(imagePath: "assets/logo/Primiter.png"),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTabBar(
                        currentIndex: tabIndex,
                        onTap: onTabTappedTabBar,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IndexedStack(
                    index: tabIndex,
                    children: const [
                      RoundTripForm(),
                      OneWayTripForm(),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const FlightDiscount(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavigationBar(
          currentIndex: bottomNavIndex,
          onTap: onItemTappedBottomNav,
        ),
      ),
    );
  }
}

