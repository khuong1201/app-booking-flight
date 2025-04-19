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
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<CheckedBaggageViewModel>(
              builder: (context, viewModel, child) {
                // Lấy tên thành phố từ mã sân bay
                final departureAirportCity = getAirportCity(flightData.departureAirport);
                final arrivalAirportCity = getAirportCity(flightData.arrivalAirport);

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Flight Info Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Logo hãng máy bay
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
                            // Thông tin chuyến bay
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
                      ),
                      const SizedBox(height: 16),
                      // Passenger Info Section
                      const SizedBox(height: 8),
                      Consumer<PassengerInfoViewModel>(
                        builder: (context, passengerViewModel, child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: passengerViewModel.passengers.length,
                            itemBuilder: (context, index) {
                              final service = additionalServicesViewModel.additionalServices[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Thông tin hành khách
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          passengerViewModel.getFullName(index),
                                          style: AppTextStyle.paragraph2.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Total: ${service.baggagePackage ?? 'None'}',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // GridView cho các gói hành lý
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
                                          onTap: () => viewModel.selectBaggage(index, '20kg', 216000),
                                        ),
                                        _buildBaggageOption(
                                          context: context,
                                          viewModel: viewModel,
                                          weight: '30kg Package',
                                          price: 324000,
                                          isSelected: service.baggagePackage == '30kg',
                                          onTap: () => viewModel.selectBaggage(index, '30kg', 324000),
                                        ),
                                        _buildBaggageOption(
                                          context: context,
                                          viewModel: viewModel,
                                          weight: '40kg Package',
                                          price: 432000,
                                          isSelected: service.baggagePackage == '40kg',
                                          onTap: () => viewModel.selectBaggage(index, '40kg', 432000),
                                        ),
                                        _buildBaggageOption(
                                          context: context,
                                          viewModel: viewModel,
                                          weight: '50kg Package',
                                          price: 584000,
                                          isSelected: service.baggagePackage == '50kg',
                                          onTap: () => viewModel.selectBaggage(index, '50kg', 584000),
                                        ),
                                        _buildBaggageOption(
                                          context: context,
                                          viewModel: viewModel,
                                          weight: '60kg Package',
                                          price: 702000,
                                          isSelected: service.baggagePackage == '60kg',
                                          onTap: () => viewModel.selectBaggage(index, '60kg', 702000),
                                        ),
                                        _buildBaggageOption(
                                          context: context,
                                          viewModel: viewModel,
                                          weight: '70kg Package',
                                          price: 810000,
                                          isSelected: service.baggagePackage == '70kg',
                                          onTap: () => viewModel.selectBaggage(index, '70kg', 810000),
                                        ),
                                        _buildBaggageOption(
                                          context: context,
                                          viewModel: viewModel,
                                          weight: 'Oversized Baggage 20kg',
                                          price: 480000,
                                          isSelected: service.baggagePackage == 'Oversized 20kg',
                                          onTap: () => viewModel.selectBaggage(index, 'Oversized 20kg', 480000),
                                        ),
                                        _buildBaggageOption(
                                          context: context,
                                          viewModel: viewModel,
                                          weight: 'Oversized Baggage 30kg',
                                          price: 594000,
                                          isSelected: service.baggagePackage == 'Oversized 30kg',
                                          onTap: () => viewModel.selectBaggage(index, 'Oversized 30kg', 594000),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Total Amount Section
                      Row(
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
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
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