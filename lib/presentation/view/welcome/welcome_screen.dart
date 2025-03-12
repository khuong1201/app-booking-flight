import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';
import 'package:booking_flight/presentation/view/welcome/welcome_page.dart';
import 'package:booking_flight/core/utils/utils.dart';
import 'package:flutter/services.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
    });
  }
  void nextPage() {
    if (currentIndex < 2) {
      controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      goToBookingFlight();
    }
  }

  void skipToLastPage() {
    if (controller.hasClients) {
      controller.jumpToPage(2);
    }
  }

  void goToBookingFlight() {
    Navigator.pushReplacementNamed(context, AppRouters.bookingFlight);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xFFE3E8F7);
    ThemeHelper.updateStatusBar(backgroundColor);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: const [
                WelcomePage(
                  imagePath: 'assets/image/welcome1.png',
                  title: 'Plan a Trip',
                  description: 'Plan your dream trip with ease. Book flights, hotels, and more, all in one place.',
                ),
                WelcomePage(
                  imagePath: 'assets/image/welcome2.png',
                  title: 'Book the Flight',
                  description: 'Your next adventure starts here. Easily plan and book your flights with our app.',
                ),
                WelcomePage(
                  imagePath: 'assets/image/welcome3.png',
                  title: 'Let’s travel',
                  description: 'Simplify your travel planning. Find the best flight deals and book your trip in seconds.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: currentIndex == 2
                ? ElevatedButton(
              onPressed: goToBookingFlight,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fixedSize: const Size(179, 44),
              ),
              child: const Text(
                'Start Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: Colors.white,
                ),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: skipToLastPage,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      decoration: TextDecoration.underline,
                      color: AppColors.neutralColor,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: index == currentIndex ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == currentIndex ? AppColors.primaryColor : const Color(0xFFD9D9D9),
                      ),
                    );
                  }),
                ),
                TextButton(
                  onPressed: nextPage,
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

