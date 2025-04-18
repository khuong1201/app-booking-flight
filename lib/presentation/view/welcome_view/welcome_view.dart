import 'package:booking_flight/presentation/view/welcome_view/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_flight/core/constants/constants.dart';
import '../../viewmodel/welcomemodel/welcome_view_model.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WelcomeViewModel(),
      child: Consumer<WelcomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFE3E8F7),
            body: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: viewModel.controller,
                    onPageChanged: viewModel.onPageChanged,
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
                  child: viewModel.currentIndex == 2
                      ? ElevatedButton(
                    onPressed: () => viewModel.goToBookingFlight(context),
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
                        onPressed: viewModel.skipToLastPage,
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
                            width: index == viewModel.currentIndex ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == viewModel.currentIndex
                                  ? AppColors.primaryColor
                                  : const Color(0xFFD9D9D9),
                            ),
                          );
                        }),
                      ),
                      TextButton(
                        onPressed: () => viewModel.nextPage(context),
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
        },
      ),
    );
  }
}
