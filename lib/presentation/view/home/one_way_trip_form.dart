import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_flight/core/constants/constants.dart';
import 'package:booking_flight/core/widget/widgets.dart';
import '../../viewmodel/home/round_trip_view_model.dart'; // Import RoundTripFormViewModel

class OneWayTripForm extends StatelessWidget {
  const OneWayTripForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoundTripFormViewModel(), // Sử dụng RoundTripFormViewModel
      child: Consumer<RoundTripFormViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3E8F7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SectionTitle(title: 'From'),
                      const SizedBox(height: 8),
                      CustomButton(
                        hintText: viewModel.departureAirport?['city'] ?? "Departing From?",
                        assetPath: AppIcons.airplaneTakeoff,
                        onTap: () => viewModel.showLocationPicker(context, true), // Sử dụng viewModel.showLocationPicker
                        textStyle: viewModel.departureAirport != null
                            ? TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
                            : null,
                      ),

                      const SectionTitle(title: 'To'),
                      const SizedBox(height: 8),
                      CustomButton(
                        hintText: viewModel.arrivalAirport?['city'] ?? "Arriving to?",
                        assetPath: AppIcons.airplaneLanding,
                        onTap: () => viewModel.showLocationPicker(context, false), // Sử dụng viewModel.showLocationPicker
                        textStyle: viewModel.arrivalAirport != null
                            ? TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
                            : null,
                      ),

                      const SectionTitle(title: 'Departure Date'),
                      const SizedBox(height: 8),
                      CustomButton(
                        hintText: viewModel.departureDate != null
                            ? "${viewModel.departureDate!.toLocal()}".split(' ')[0]
                            : "Choose Date",
                        assetPath: AppIcons.calendarArrowRight,
                        onTap: () => viewModel.selectDate(context, true, false), // Sử dụng viewModel.selectDate
                        textStyle: viewModel.departureDate != null
                            ? TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
                            : null,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionTitle(title: 'Passenger'),
                                const SizedBox(height: 8),
                                CustomButton(
                                  hintText: "${viewModel.passengers} passenger(s)",
                                  assetPath: AppIcons.personMultiple,
                                  onTap: () => viewModel.showPassengerPicker(context), // Sử dụng viewModel.showPassengerPicker
                                  textStyle: viewModel.passengers > 1
                                      ? TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionTitle(title: 'Seat Class'),
                                const SizedBox(height: 8),
                                CustomButton(
                                  hintText: viewModel.seatClass,
                                  assetPath: AppIcons.seat,
                                  onTap: () => viewModel.showSeatPicker(context), // Sử dụng viewModel.showSeatPicker
                                  textStyle: viewModel.seatClass != 'Economy'
                                      ? TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => viewModel.searchFlights(context), // Sử dụng viewModel.searchFlights
                          child: Container(
                            width: 312,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "Search Flights",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFF2F2F2),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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