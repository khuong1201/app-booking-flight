import 'package:booking_flight/core/constants/app_colors.dart';
import 'package:booking_flight/core/constants/text_styles.dart';
import 'package:booking_flight/data/additional_services_model.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/additional_services_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/payment_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:booking_flight/data/SearchViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Reusable Section Title Widget (for non-expandable sections)
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: AppTextStyle.body3.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// Reusable Expandable Section Widget (for expandable sections)
class ExpandableSection extends StatelessWidget {
  final String title;
  final Widget content;
  final Color? titleBackgroundColor;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.content,
    this.titleBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Container(
          margin: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: titleBackgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12), // Only vertical padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  title,
                  style: AppTextStyle.body3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.expand_more,
                  color: Colors.black54,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        trailing: const SizedBox.shrink(),
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        children: [
          Container(
            color: Colors.white,
            child: content,
          ),
        ],
      ),
    );
  }
}

// Reusable Card Container Widget
class CardContainer extends StatelessWidget {
  final Widget child;
  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

// Reusable ListTile Widget for Key-Value Pairs
class CustomListTile extends StatelessWidget {
  final String title;
  final String trailing;
  final bool isBoldTrailing;
  final Color? titleColor;
  final Color? trailingColor;

  const CustomListTile({
    super.key,
    required this.title,
    required this.trailing,
    this.isBoldTrailing = false,
    this.titleColor,
    this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.caption1.copyWith(
                color: titleColor ?? Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            trailing,
            style: AppTextStyle.caption1.copyWith(
              fontWeight: isBoldTrailing ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
              color: trailingColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  final FlightData flightData;
  final SearchViewModel searchViewModel;
  final PassengerInfoViewModel passengerInfoViewModel;
  final AdditionalServicesViewModel additionalServicesViewModel;

  const PaymentScreen({
    super.key,
    required this.flightData,
    required this.searchViewModel,
    required this.passengerInfoViewModel,
    required this.additionalServicesViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentViewModel(
        flightData: flightData,
        searchViewModel: searchViewModel,
        passengerInfoViewModel: passengerInfoViewModel,
        additionalServicesViewModel: additionalServicesViewModel,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            'Payment',
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
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Consumer<PaymentViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Payment Method Section (Non-Expandable)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SectionTitle(title: 'Payment Method'),
                                  CardContainer(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            'Account/Card',
                                            style: AppTextStyle.paragraph2.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                          trailing: const Icon(
                                            Icons.check_circle,
                                            color: AppColors.primaryColor,
                                            size: 20,
                                          ),
                                          onTap: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Payment method selection coming soon!'),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SectionTitle(title: 'Payment Detail'),
                            // Service Payment Section (Flight Cost, Expandable)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ExpandableSection(
                                title: 'Service Payment',
                                titleBackgroundColor: const Color(0xFFE3E8F7),
                                content: CardContainer(
                                  child: Column(
                                    children: [
                                      CustomListTile(
                                        title: 'Service',
                                        trailing: '${additionalServicesViewModel.airlineInfo}',
                                        isBoldTrailing: true,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: const Divider(height: 16, thickness: 1),
                                      ),
                                      CustomListTile(
                                        title: 'Number of Insured Persons',
                                        trailing: '${viewModel.passengerCount}',
                                        isBoldTrailing: true,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: const Divider(height: 16, thickness: 1),
                                      ),
                                      CustomListTile(
                                        title: 'Amount',
                                        trailing: '${viewModel.formattedFlightPrice} VND',
                                        isBoldTrailing: true,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: const Divider(height: 16, thickness: 1),
                                      ),
                                      CustomListTile(
                                        title: 'Subtotal',
                                        trailing: '${viewModel.formattedFlightPrice} VND',
                                        isBoldTrailing: true,
                                        trailingColor: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Insurance Payment Section (Expandable, with custom title background)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ExpandableSection(
                                title: 'Insurance Payment',
                                titleBackgroundColor: const Color(0xFFE3E8F7),
                                content: CardContainer(
                                  child: Column(
                                    children: [
                                      CustomListTile(
                                        title: 'Number of Insured Persons',
                                        trailing: '${viewModel.passengerCount}',
                                        isBoldTrailing: true,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: const Divider(height: 16, thickness: 1),
                                      ),
                                      if (additionalServicesViewModel.comprehensiveInsurance)
                                        CustomListTile(
                                          title: 'Insurance Fee',
                                          trailing: viewModel.formatCurrency(
                                            viewModel.additionalServices.fold(
                                              0.0,
                                                  (sum, service) => sum + service.comprehensiveInsuranceCost,
                                            ),
                                          ),
                                          isBoldTrailing: true,
                                        ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: const Divider(height: 16, thickness: 1),
                                      ),
                                      if (additionalServicesViewModel.flightDelayInsurance)
                                        CustomListTile(
                                          title: 'Flight Delay Insurance',
                                          trailing: viewModel.formatCurrency(
                                            viewModel.additionalServices.fold(
                                              0.0,
                                                  (sum, service) => sum + service.flightDelayInsuranceCost,
                                            ),
                                          ),
                                          isBoldTrailing: true,
                                        ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: const Divider(height: 16, thickness: 1),
                                      ),
                                      CustomListTile(
                                        title: 'Service Fee',
                                        trailing: 'Free',
                                        isBoldTrailing: true,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: const Divider(height: 16, thickness: 1),
                                      ),
                                      CustomListTile(
                                        title: 'Subtotal',
                                        trailing: '${viewModel.formattedInsuranceTotal} VND',
                                        isBoldTrailing: true,
                                        trailingColor: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Additional Services Section (Expandable)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ExpandableSection(
                                title: 'Additional Services',
                                titleBackgroundColor: const Color(0xFFE3E8F7),
                                content: CardContainer(
                                  child: viewModel.additionalServices.isEmpty
                                      ? const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                    child: Text(
                                      'No additional services selected',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                      : Column(
                                    children: [
                                      ...viewModel.additionalServices.asMap().entries.map((entry) {
                                        final service = entry.value;
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (service.baggagePackage != null && service.baggageCost > 0)
                                              CustomListTile(
                                                title: '20kg Checked Baggage',
                                                trailing: '${viewModel.formatCurrency(service.baggageCost)} VND',
                                              ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16),
                                              child: const Divider(height: 16, thickness: 1),
                                            ),
                                            if (service.seatSelection != null && service.seatCost > 0)
                                              CustomListTile(
                                                title: 'Seat (${service.seatSelection})',
                                                trailing: '${viewModel.formatCurrency(service.seatCost)} VND',
                                              ),
                                            if (service.meal != null && service.mealCost > 0)
                                              CustomListTile(
                                                title: 'Meal (${service.meal}, x${service.mealQuantity})',
                                                trailing: '${viewModel.formatCurrency(service.mealCost)} VND',
                                              ),
                                          ],
                                        );
                                      }).toList(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: const Divider(height: 16, thickness: 1),
                                      ),
                                      CustomListTile(
                                        title: 'Subtotal',
                                        trailing: '${viewModel.formattedAdditionalServicesTotal} VND',
                                        isBoldTrailing: true,
                                        trailingColor: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Payment Information Section (Expandable)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ExpandableSection(
                                title: 'Payment Information',
                                titleBackgroundColor: const Color(0xFFE3E8F7),
                                content: CardContainer(
                                  child: Column(
                                    children: [
                                      CustomListTile(
                                        title: 'Subtotal',
                                        trailing: '${viewModel.formattedTotalAmount} VND',
                                        isBoldTrailing: true,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: const Divider(height: 16, thickness: 1),
                                      ),
                                      CustomListTile(
                                        title: 'Total Promotions',
                                        trailing: '0 VND',
                                        isBoldTrailing: true,
                                        titleColor: Colors.orange,
                                        trailingColor: Colors.orange,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: const Divider(height: 16, thickness: 1),
                                      ),
                                      CustomListTile(
                                        title: 'Total',
                                        trailing: '${viewModel.formattedTotalAmount} VND',
                                        isBoldTrailing: true,
                                        trailingColor: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    // Bottom Fixed Container with Two Buttons
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          // Confirm Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () => viewModel.initiatePayment(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                              ),
                              child: viewModel.isLoading
                                  ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                'Confirm',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Pay Later Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pay later option coming soon!'),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Pay later',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}