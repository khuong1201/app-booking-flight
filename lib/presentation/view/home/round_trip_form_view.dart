import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/widget/custom_button_widget.dart';
import '../../../core/widget/section_title_widget.dart';
import '../../viewmodel/home/round_trip_view_model.dart';
import 'package:intl/intl.dart';
import '../search/search_number_of_passenger_view.dart';

class RoundTripForm extends StatelessWidget {
  const RoundTripForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Cung cấp Provider trực tiếp tại đây
    return ChangeNotifierProvider<RoundTripFormViewModel>(
      create: (context) => RoundTripFormViewModel(),
      child: Consumer<RoundTripFormViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'From'),
                const SizedBox(height: 8),
                CustomButton(
                  hintText: viewModel.departureAirport?['city'] ?? "Departing From?",
                  assetPath: AppIcons.airplaneTakeoff,
                  onTap: () => viewModel.showLocationPicker(context, true),
                  textStyle: viewModel.departureAirport != null
                      ? const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
                      : null,
                ),
                const SectionTitle(title: 'To'),
                const SizedBox(height: 8),
                CustomButton(
                  hintText: viewModel.arrivalAirport?['city'] ?? "Arriving to?",
                  assetPath: AppIcons.airplaneLanding,
                  onTap: () => viewModel.showLocationPicker(context, false),
                  textStyle: viewModel.arrivalAirport != null
                      ? const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
                      : null,
                ),
                const SectionTitle(title: 'Departure Date'),
                const SizedBox(height: 8),
                CustomButton(
                  hintText: viewModel.departureDate != null
                      ? DateFormat('EEE MMM d').format(viewModel.departureDate!)
                      : "Choose Date",
                  assetPath: AppIcons.calendarArrowRight,
                  onTap: () => viewModel.selectDate(context, true, true),
                  textStyle: viewModel.departureDate != null
                      ? const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
                      : null,
                ),
                const SectionTitle(title: 'Return Date'),
                const SizedBox(height: 8),
                CustomButton(
                  hintText: viewModel.returnDate != null
                      ? DateFormat('EEE MMM d').format(viewModel.returnDate!)
                      : "Choose Date",
                  assetPath: AppIcons.calendarArrowRight,
                  onTap: () => viewModel.selectDate(context, false, true),
                  textStyle: viewModel.returnDate != null
                      ? const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(title: 'Passenger'),
                          const SizedBox(height: 8),
                          CustomButton(
                            hintText: "${viewModel.passengerAdults + viewModel.passengerChilds + viewModel.passengerInfants} passenger(s)",
                            assetPath: AppIcons.personMultiple,
                            onTap: () async {
                              final result = await showModalBottomSheet<Map<String, int>>(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                                ),
                                builder: (context) => PassengerSelectionSheet(
                                  initialAdults: viewModel.passengerAdults,
                                  initialChilds: viewModel.passengerChilds,
                                  initialInfants: viewModel.passengerInfants,
                                ),
                              );
                              if (result != null && result.containsKey('adults') && result.containsKey('childs') && result.containsKey('infants')) {
                                viewModel.updatePassengerCount(
                                  adults: result['adults']!,
                                  childs: result['childs']!,
                                  infants: result['infants']!,
                                );
                              }
                            },
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
                            onTap: () => viewModel.showSeatPicker(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => viewModel.searchFlights(context),
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
                            color: Colors.white,
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
          );
        },
      ),
    );
  }
}
