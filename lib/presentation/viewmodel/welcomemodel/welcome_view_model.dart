import 'package:flutter/material.dart';
import 'package:booking_flight/presentation/view/home/booking_flight_view.dart';

class WelcomeViewModel extends ChangeNotifier {
  final PageController controller = PageController();
  int currentIndex = 0;

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void nextPage(BuildContext context) {
    if (currentIndex < 2) {
      controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      goToBookingFlight(context);
    }
  }

  void skipToLastPage() {
    if (controller.hasClients) {
      controller.jumpToPage(2);
    }
  }

  void goToBookingFlight(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookingFlightScreen()),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}