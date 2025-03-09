import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  void nextPage() {
    if (currentIndex < 2) {
      controller.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home'); // Điều hướng đến màn hình chính
    }
  }

  void skipToLastPage() {
    controller.jumpToPage(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              children: [
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
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: skipToLastPage,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      width: index == currentIndex ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == currentIndex ? AppColors.primaryColor : Color(0xFFD9D9D9),
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
                      decoration: TextDecoration.underline,
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

class WelcomePage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const WelcomePage({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Image.asset(
            imagePath,
            width: 412,
            height: 411,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 28, bottom: 8),
            child: Text(
              title,
              style: AppTextStyle.heading2Pri,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Text(
              description,
              style: AppTextStyle.body3,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
