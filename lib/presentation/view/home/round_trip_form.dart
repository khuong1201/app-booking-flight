import 'package:booking_flight/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:booking_flight/core/widget/widgets.dart';

class RoundTripForm extends StatelessWidget {
  const RoundTripForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Scroll nếu nội dung dài
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Container chứa toàn bộ form + nút
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3E8F7),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16),),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SectionTitle(title: 'From'),
                const CustomTextField(hintText: "Departing From?", assetPath: AppIcons.airplaneTakeoff),

                const SectionTitle(title: 'To'),
                const CustomTextField(hintText: "Arriving to?", assetPath: AppIcons.airplaneLanding),

                const SectionTitle(title: 'Departure Date'),
                const CustomTextField(hintText: "Choose Date", assetPath: AppIcons.calendarArrowRight),

                const SectionTitle(title: 'Return Date'),
                const CustomTextField(hintText: "Choose Date", assetPath: AppIcons.calendarArrowLeft),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(title: 'Passenger'),
                          const CustomTextField(hintText: "1 passenger?", assetPath: AppIcons.personMultiple),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(title: 'Seat Class'),
                          const CustomTextField(hintText: "Economy?", assetPath: AppIcons.seat),
                        ],
                      ),
                    ),
                  ],
                ),

                /// Nút "Search Flights"
                Align(
                  alignment: Alignment.center,
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
                SizedBox(height: 10,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
