import 'package:booking_flight/core/constants/app_colors.dart';
import 'package:booking_flight/core/constants/text_styles.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/checked_baggage_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/additional_services_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CheckedBaggageScreen extends StatelessWidget {
  final FlightData flightData;
  final String routerTrip;
  final String airlineInfo;
  final PassengerInfoViewModel passengerInfoViewModel;
  final AdditionalServicesViewModel additionalServicesViewModel;

  const CheckedBaggageScreen({
    super.key,
    required this.flightData,
    required this.routerTrip,
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
          create: (_) => CheckedBaggageViewModel(
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
            'Checked Baggage',
            style: TextStyle(color: Colors.white, fontSize: 18),
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
        body: SafeArea(
          child: Stack(
            children: [
              // Main content (scrollable)
              SingleChildScrollView(
                child: Container(
                  color: const Color(0xFFE3E8F7),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Container trắng bao quanh GridView và nội dung liên quan
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Consumer<CheckedBaggageViewModel>(
                          builder: (context, viewModel, child) {
                            final departureAirportCity = getAirportCity(flightData.departureAirport);
                            final arrivalAirportCity = getAirportCity(flightData.arrivalAirport);

                            return Column(
                              mainAxisSize: MainAxisSize.min, // Chỉ chiếm không gian cần thiết
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                // Flight information
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$departureAirportCity (${flightData.departureAirport}) - $arrivalAirportCity (${flightData.arrivalAirport})',
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
                                const SizedBox(height: 16),
                                const Divider(),
                                // Passenger (only index = 0)
                                Consumer<PassengerInfoViewModel>(
                                  builder: (context, passengerViewModel, child) {
                                    if (passengerViewModel.passengers.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          'Không có hành khách nào.',
                                          style: TextStyle(fontSize: 16, color: Colors.grey),
                                        ),
                                      );
                                    }

                                    final service = additionalServicesViewModel.additionalServices[0];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    passengerViewModel.getFullName(0),
                                                    style: AppTextStyle.paragraph2.copyWith(fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Total: ${service.baggagePackage ?? 'None'}',
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              GridView.count(
                                                crossAxisCount: 2,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                crossAxisSpacing: 16,
                                                mainAxisSpacing: 16,
                                                childAspectRatio: 1.2,
                                                padding: const EdgeInsets.all(8),
                                                children: [
                                                  _buildBaggageOption(
                                                    context: context,
                                                    viewModel: viewModel,
                                                    weight: '20kg Package',
                                                    price: 216000,
                                                    isSelected: service.baggagePackage == '20kg',
                                                    onTap: () => viewModel.selectBaggage(0, '20kg', 216000),
                                                  ),
                                                  _buildBaggageOption(
                                                    context: context,
                                                    viewModel: viewModel,
                                                    weight: '30kg Package',
                                                    price: 324000,
                                                    isSelected: service.baggagePackage == '30kg',
                                                    onTap: () => viewModel.selectBaggage(0, '30kg', 324000),
                                                  ),
                                                  _buildBaggageOption(
                                                    context: context,
                                                    viewModel: viewModel,
                                                    weight: '40kg Package',
                                                    price: 432000,
                                                    isSelected: service.baggagePackage == '40kg',
                                                    onTap: () => viewModel.selectBaggage(0, '40kg', 432000),
                                                  ),
                                                  _buildBaggageOption(
                                                    context: context,
                                                    viewModel: viewModel,
                                                    weight: '50kg Package',
                                                    price: 584000,
                                                    isSelected: service.baggagePackage == '50kg',
                                                    onTap: () => viewModel.selectBaggage(0, '50kg', 584000),
                                                  ),
                                                  _buildBaggageOption(
                                                    context: context,
                                                    viewModel: viewModel,
                                                    weight: '60kg Package',
                                                    price: 702000,
                                                    isSelected: service.baggagePackage == '60kg',
                                                    onTap: () => viewModel.selectBaggage(0, '60kg', 702000),
                                                  ),
                                                  _buildBaggageOption(
                                                    context: context,
                                                    viewModel: viewModel,
                                                    weight: '70kg Package',
                                                    price: 810000,
                                                    isSelected: service.baggagePackage == '70kg',
                                                    onTap: () => viewModel.selectBaggage(0, '70kg', 810000),
                                                  ),
                                                  _buildBaggageOption(
                                                    context: context,
                                                    viewModel: viewModel,
                                                    weight: 'Oversized Baggage 20kg',
                                                    price: 480000,
                                                    isSelected: service.baggagePackage == 'Oversized 20kg',
                                                    onTap: () => viewModel.selectBaggage(0, 'Oversized 20kg', 480000),
                                                  ),
                                                  _buildBaggageOption(
                                                    context: context,
                                                    viewModel: viewModel,
                                                    weight: 'Oversized Baggage 30kg',
                                                    price: 594000,
                                                    isSelected: service.baggagePackage == 'Oversized 30kg',
                                                    onTap: () => viewModel.selectBaggage(0, 'Oversized 30kg', 594000),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      // Khoảng trống sau Container trắng
                      const SizedBox(height: 100), // Khoảng trống trước khi đến Positioned
                    ],
                  ),
                ),
              ),
              // Fixed bottom bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Consumer<CheckedBaggageViewModel>(
                    builder: (context, viewModel, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${viewModel.formattedTotalBaggageCost} VND',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: const Text('Select'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBaggageOption({
    required BuildContext context,
    required CheckedBaggageViewModel viewModel,
    required String weight,
    required double price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : const Color(0xFFE6E6E6),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? const Color(0xFFE3E8F7) : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/Vector.svg',
              width: 46,
              height: 40,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primaryColor : AppColors.neutralColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weight,
              style: AppTextStyle.caption1.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primaryColor : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '+${viewModel.formatCurrency(price)} VND',
              style: AppTextStyle.caption2.copyWith(
                fontSize: 12,
                color: isSelected ? AppColors.primaryColor : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}