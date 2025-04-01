import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/home/flight_discount_view_model.dart';
import 'flight_card.dart';

class FlightDiscount extends StatelessWidget {
  const FlightDiscount({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FlightDiscountViewModel(),
      child: Consumer<FlightDiscountViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Flights discount up to 50%",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    buildToggleButton("One - way", true, viewModel),
                    const SizedBox(width: 8),
                    buildToggleButton("Round trip", false, viewModel),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.filteredFlights.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FlightCard(flight: viewModel.filteredFlights[index]),
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

  Widget buildToggleButton(String text, bool value, FlightDiscountViewModel viewModel) {
    bool isSelected = viewModel.isOneTrip == value;
    return GestureDetector(
      onTap: () => viewModel.toggleTripType(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : const Color(0xFFE6E6E6),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFFE6E6E6) : AppColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.21,
          ),
        ),
      ),
    );
  }
}
