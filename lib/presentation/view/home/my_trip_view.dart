import 'package:booking_flight/core/constants/app_colors.dart';
import 'package:booking_flight/core/constants/text_styles.dart';
import 'package:booking_flight/data/trip_model.dart';
import 'package:booking_flight/presentation/viewmodel/home/my_trip_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MyTripScreen extends StatelessWidget {
  const MyTripScreen({super.key});

  Widget _buildTripCard(Trip trip, MyTripViewModel viewModel, BuildContext context) {
    final isSelected = trip.id == viewModel.selectedTripId;
    return GestureDetector(
      onTap: () {
        debugPrint('Nhấn vào chuyến đi: ${trip.id}');
        viewModel.selectTrip(trip.id);
        viewModel.showTicketDetailsSheet(context, trip);
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          trip.id,
                          style: AppTextStyle.caption1.copyWith(
                            color: const Color(0xFFB8B8B8),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          viewModel.formatCurrency(trip.totalAmount.toStringAsFixed(0)),
                          style: AppTextStyle.paragraph2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      trip.flightData != null
                          ? '${trip.flightData!.departureAirport} → ${trip.flightData!.arrivalAirport}'
                          : 'No flight information',
                      style: AppTextStyle.caption1.copyWith(
                        fontSize: 14,
                        color: trip.flightData != null ? Colors.black87 : Colors.red,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      viewModel.formatDateTime(trip.createdAt),
                      style: AppTextStyle.caption2.copyWith(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyTripViewModel(),
      child: Consumer<MyTripViewModel>(
        builder: (context, tripViewModel, child) {
          debugPrint('MyTripScreen rebuild');
          if (!tripViewModel.isLoading && tripViewModel.allTrips.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No flights to display')),
              );
            });
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              elevation: 0,
              title: Text(
                'My Flight',
                style: AppTextStyle.body3.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFA3B2E4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(12),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: const TextStyle(color: Colors.black54),
                          prefixIcon: const Icon(Icons.search, color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          debugPrint('Search: $value');
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: tripViewModel.isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                      : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tripViewModel.recentTrips.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              'Recent flights',
                              style: AppTextStyle.body3.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          ...tripViewModel.recentTrips.map(
                                (trip) => _buildTripCard(trip, tripViewModel, context),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            'All Flights',
                            style: AppTextStyle.body3.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (tripViewModel.allTrips.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/Trip empty.svg',
                                    width: 64,
                                    height: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'You don’t have any active bookings',
                                    style: AppTextStyle.body3.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Explore new adventures with our inspirational ideas below!\n'
                                        'If you can’t find your previous booking, try logging in with the\n'
                                        'email you used when booking.',
                                    style: AppTextStyle.caption1.copyWith(
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...tripViewModel.allTrips.map(
                                (trip) => _buildTripCard(trip, tripViewModel, context),
                          ),
                      ],
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