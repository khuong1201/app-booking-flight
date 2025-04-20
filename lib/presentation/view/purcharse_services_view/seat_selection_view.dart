import 'package:booking_flight/core/constants/app_colors.dart';
import 'package:booking_flight/core/constants/text_styles.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/additional_services_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/seat_selection_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PassengerButtonWidget extends StatelessWidget {
  final int index;
  final String passengerName;
  final SeatSelectionViewModel viewModel;

  const PassengerButtonWidget({
    super.key,
    required this.index,
    required this.passengerName,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SeatSelectionViewModel>(
      builder: (context, viewModel, child) {
        final bool isSelected = viewModel.selectedPassenger == index;
        final String seat = viewModel.getSelectedSeatForPassenger(index);
        final double cost = viewModel.getSeatCostForPassenger(index);

        return GestureDetector(
          onTap: () {
            viewModel.togglePassengerSelection(index);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : Colors.grey,
                width: 2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryColor : Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passengerName.toUpperCase(),
                      style: AppTextStyle.body3.copyWith(
                        fontSize: 14,
                        color: isSelected ? AppColors.primaryColor : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Seat: $seat   +${viewModel.formatCurrency(cost)} VND',
                      style: AppTextStyle.caption2.copyWith(
                        fontSize: 14,
                        color: isSelected ? AppColors.primaryColor : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PassengerSummaryWidget extends StatelessWidget {
  final PassengerInfoViewModel passengerInfoViewModel;

  const PassengerSummaryWidget({
    super.key,
    required this.passengerInfoViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFE3E8F7),
      ),
      child: Consumer<SeatSelectionViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                passengerInfoViewModel.passengers.length,
                    (index) => PassengerButtonWidget(
                  index: index,
                  passengerName: passengerInfoViewModel.getFullName(index),
                  viewModel: viewModel,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SeatSelectionScreen extends StatelessWidget {
  final FlightData flightData;
  final String airlineInfo;
  final PassengerInfoViewModel passengerInfoViewModel;
  final AdditionalServicesViewModel additionalServicesViewModel;

  const SeatSelectionScreen({
    super.key,
    required this.flightData,
    required this.airlineInfo,
    required this.passengerInfoViewModel,
    required this.additionalServicesViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: passengerInfoViewModel),
        ChangeNotifierProvider.value(value: additionalServicesViewModel),
        ChangeNotifierProvider(
          create: (_) => SeatSelectionViewModel(
            flightData: flightData,
            passengerInfoViewModel: passengerInfoViewModel,
            additionalServicesViewModel: additionalServicesViewModel,
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            'Select Seat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/Chevron.svg',
                  width: 16,
                  height: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: const Color(0xFFE3E8F7),
          child: Column(
            children: [
              // Flight Info Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Airline Logo
                    Image.asset(
                      flightData.airlineLogo,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.flight,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Flight Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${getAirportCity(flightData.departureAirport)} (${flightData.departureAirport}) - ${getAirportCity(flightData.arrivalAirport)} (${flightData.arrivalAirport})',
                            style: AppTextStyle.body3.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            airlineInfo,
                            style: AppTextStyle.caption2.copyWith(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Passenger Selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: PassengerSummaryWidget(
                  passengerInfoViewModel: passengerInfoViewModel,
                ),
              ),
              // Wrapped Legend and Seat Grid
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Seat Status Legend
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // First row: Sold, Front seat, Near emergency seat
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: _buildLegendItem(const Color(0xFFCFCFC4), 'Sold'),
                                ),
                                Expanded(
                                  child: _buildLegendItem(const Color(0xFFFFD1DC), 'Front seat\n43,200VND'),
                                ),
                                Expanded(
                                  child: _buildLegendItem(const Color(0xFFAAF0D1), 'Near emergency seat\n97,200VND'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Second row: Selected, Special seat, Regular seat
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: _buildLegendItem(AppColors.primaryColor, 'Selected'),
                                ),
                                Expanded(
                                  child: _buildLegendItem(const Color(0xFFFFDAB9), 'Special seat\n97,200VND'),
                                ),
                                Expanded(
                                  child: _buildLegendItem(const Color(0xFFD7BDE2), 'Regular seat\n32,400VND'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Column Headers (A, B, C, D, E, F) - Fixed at the top
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            for (var col in ['A', 'B', 'C', '', 'D', 'E', 'F'])
                              Expanded(
                                child: Center(
                                  child: Text(
                                    col,
                                    style: AppTextStyle.body3.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Seat Grid - Scrollable
                      Expanded(
                        child: Consumer<SeatSelectionViewModel>(
                          builder: (context, viewModel, child) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Column(
                                  children: [
                                    // Seat Rows
                                    for (int row = 1; row <= 40; row++)
                                      Row(
                                        children: [
                                          // Seats (A, B, C) - map to _seatAvailability cols 0, 1, 2
                                          for (int col = 0; col < 3; col++)
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(4),
                                                child: _buildSeat(
                                                  row: row,
                                                  col: col,
                                                  viewModel: viewModel,
                                                  isColumnA: col == 0,
                                                ),
                                              ),
                                            ),
                                          // Gap with Row Number
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Center(
                                                child: Text(
                                                  '$row',
                                                  style: AppTextStyle.caption1.copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Seats (D, E, F) - map to _seatAvailability cols 3, 4, 5
                                          for (int col = 3; col < 6; col++)
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(4),
                                                child: _buildSeat(
                                                  row: row,
                                                  col: col,
                                                  viewModel: viewModel,
                                                  isColumnF: col == 5,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Bar: Total Cost and Select Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<SeatSelectionViewModel>(
                      builder: (context, viewModel, child) {
                        return Text(
                          '${viewModel.formattedTotalSeatCost} VND',
                          style: AppTextStyle.body3.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Select',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeat({
    required int row,
    required int col,
    required SeatSelectionViewModel viewModel,
    bool isColumnA = false,
    bool isColumnF = false,
  }) {
    // Skip seats in columns A and F for rows 11 and 26
    if ((isColumnA || isColumnF) && (row == 11 || row == 26)) {
      return const SizedBox(); // Empty space
    }

    Color seatColor;

    final passengerIndex = viewModel.selectedPassenger ?? -1;
    if (passengerIndex >= 0 && viewModel.isSeatSelectedByCurrentPassenger(row, col, passengerIndex)) {
      seatColor = AppColors.primaryColor; // Selected by current passenger
    } else if (viewModel.isSeatSelected(row, col)) {
      seatColor = const Color(0xFFCFCFC4); // Selected by another passenger or sold
    } else if (!viewModel.isSeatAvailable(row, col)) {
      seatColor = const Color(0xFFCFCFC4); // Sold
    } else {
      // Determine seat type based on row and column
      if (row == 11 || row == 27 || (row == 12 && (col == 0 || col == 5))) {
        // Near Emergency Seat
        seatColor = const Color(0xFFAAF0D1);
      } else if (row >= 1 && row <= 5) {
        // Special Seat
        seatColor = const Color(0xFFFFDAB9);
      } else if (row >= 6 && row <= 26) {
        // Front Seat
        seatColor = const Color(0xFFFFD1DC);
      } else {
        // Regular Seat (rows 28 to 40)
        seatColor = const Color(0xFFD7BDE2);
      }
    }

    return GestureDetector(
      onTap: viewModel.selectedPassenger != null
          ? () {
        viewModel.toggleSeatForPassenger(row, col, viewModel.selectedPassenger!);
      }
          : null, // Disable tap if no passenger is selected
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          'assets/icons/seat.svg',
          width: 26,
          height: 21,
          colorFilter: ColorFilter.mode(
            seatColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120), // Ensure consistent width
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/seat.svg',
            width: 22,
            height: 18,
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.caption2.copyWith(
                color: const Color(0xFF9C9C9C),
                fontSize: 10,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}