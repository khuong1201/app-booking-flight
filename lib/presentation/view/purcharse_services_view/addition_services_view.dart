import 'package:booking_flight/core/constants/app_colors.dart';
import 'package:booking_flight/core/constants/text_styles.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/view/purcharse_services_view/checked_baggage_view.dart';
import 'package:booking_flight/presentation/view/purcharse_services_view/order_meal_view.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/additional_services_view_model.dart';
import 'package:booking_flight/data/SearchViewModel.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AdditionalServicesScreen extends StatelessWidget {
  final FlightData flightData;
  final SearchViewModel searchViewModel;
  final PassengerInfoViewModel passengerInfoViewModel;

  const AdditionalServicesScreen({
    super.key,
    required this.flightData,
    required this.searchViewModel,
    required this.passengerInfoViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: passengerInfoViewModel),
        ChangeNotifierProvider(
          create: (_) => AdditionalServicesViewModel(
            flightData: flightData,
            searchViewModel: searchViewModel,
            passengerInfoViewModel: passengerInfoViewModel,
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            'Purchase Additional Services',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: const Color(0xFFE3E8F7),
          child: Consumer<AdditionalServicesViewModel>(
            builder: (context, viewModel, child) {
              final departureAirportCity = getAirportCity(flightData.departureAirport);
              final arrivalAirportCity = getAirportCity(flightData.arrivalAirport);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flight Info Section
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
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
                                  viewModel.flightDateTime,
                                  style: AppTextStyle.caption1.copyWith(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  viewModel.airlineInfo,
                                  style: AppTextStyle.caption2.copyWith(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Nút mở chi tiết vé
                          IconButton(
                            icon: const Icon(
                              Icons.expand_more,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              viewModel.showTicketDetailsSheet(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Additional Services Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Additional Services',
                        style: AppTextStyle.body3.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF474747),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Checked Baggage
                          ListTile(
                            leading: SvgPicture.asset(
                              'assets/icons/lucide_baggage-claim.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            title: const Text(
                              'Checked Baggage',
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: SvgPicture.asset(
                              'assets/icons/tabler_plus.svg',
                              width: 24,
                              height: 24,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckedBaggageScreen(
                                    flightData: flightData,
                                    routerTrip:
                                    '$departureAirportCity (${flightData.departureAirport}) - $arrivalAirportCity (${flightData.arrivalAirport})',
                                    airlineInfo: viewModel.airlineInfo,
                                    passengerInfoViewModel: passengerInfoViewModel,
                                    additionalServicesViewModel: viewModel,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Seat Selection
                          ListTile(
                            leading: SvgPicture.asset(
                              'assets/icons/hugeicons_seat-selector.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            title: const Text(
                              'Seat Selection',
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: SvgPicture.asset(
                              'assets/icons/tabler_plus.svg',
                              width: 24,
                              height: 24,
                            ),
                            onTap: () {
                              viewModel.addService('Seat Selection');
                            },
                          ),
                          // Meal
                          ListTile(
                            leading: SvgPicture.asset(
                              'assets/icons/silverware-fork-knife.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            title: const Text(
                              'Meal',
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: SvgPicture.asset(
                              'assets/icons/tabler_plus.svg',
                              width: 24,
                              height: 24,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderMealScreen(
                                    flightData: flightData,
                                    routerTrip:
                                    '$departureAirportCity (${flightData.departureAirport}) - $arrivalAirportCity (${flightData.arrivalAirport})',
                                    airlineInfo: viewModel.airlineInfo,
                                    passengerInfoViewModel: passengerInfoViewModel,
                                    additionalServicesViewModel: viewModel,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Insurance Services Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Insurance Services',
                        style: AppTextStyle.body3.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF474747),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Comprehensive Travel Insurance
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: viewModel.comprehensiveInsurance,
                                onChanged: (value) =>
                                    viewModel.toggleComprehensiveInsurance(value!),
                                activeColor: AppColors.primaryColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Comprehensive Travel Insurance',
                                  style: AppTextStyle.paragraph2.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 32, bottom: 8),
                            child: Text(
                              '• Receive immediately 888,000 VND / person / trip for flights delayed over consecutive hours.\n'
                                  '• Protection against accident risks, lost luggage, property, compensation up to 200,000,000 VND.',
                              style: TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ),
                          IntrinsicWidth(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE64F03).withOpacity(0.16),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '35,000 VND / passenger / trip',
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ),
                          ),
                          const Divider(height: 24),
                          // Flight Delay Insurance
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: viewModel.flightDelayInsurance,
                                onChanged: (value) =>
                                    viewModel.toggleFlightDelayInsurance(value!),
                                activeColor: AppColors.primaryColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Flight Delay Insurance',
                                  style: AppTextStyle.paragraph2.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 32, bottom: 8),
                            child: Text(
                              '• Receive immediately 500,000 VND / person / trip for flights delayed over 2 consecutive hours.',
                              style: TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ),
                          IntrinsicWidth(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE64F03).withOpacity(0.16),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '35,000 VND / passenger / trip',
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Total Amount Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total',
                                  style: AppTextStyle.body3.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Includes taxes and fees',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${viewModel.formattedTotalAmount} VND',
                                  style: AppTextStyle.body3.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.expand_more,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ],
                            ),
                            children: [
                              Consumer<PassengerInfoViewModel>(
                                builder: (context, passengerViewModel, child) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: passengerViewModel.passengers.length,
                                    itemBuilder: (context, index) {
                                      final service = viewModel.additionalServices[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              passengerViewModel.getFullName(index),
                                              style: AppTextStyle.paragraph2.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Baggage: ${service.baggagePackage ?? 'None'} - ${viewModel.formatCurrency(service.baggageCost)} VND',
                                              style: AppTextStyle.caption2.copyWith(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Meal: ${service.meal ?? 'None'} ${service.mealQuantity > 0 ? '(x${service.mealQuantity})' : ''} - ${viewModel.formatCurrency(service.mealCost)} VND',
                                              style: AppTextStyle.caption2.copyWith(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Seat: ${service.seatSelection ?? 'None'} - ${viewModel.formatCurrency(service.seatCost)} VND',
                                              style: AppTextStyle.caption2.copyWith(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                          // Continue Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => viewModel.continueAction(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}