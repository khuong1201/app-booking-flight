import 'package:booking_flight/core/constants/app_colors.dart';
import 'package:booking_flight/core/constants/text_styles.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/additional_services_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/purchase_services_viewmodel/order_meal_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// PassengerButtonWidget
class PassengerButtonWidget extends StatelessWidget {
  final int index;
  final String passengerName;
  final OrderMealViewModel viewModel;

  const PassengerButtonWidget({
    super.key,
    required this.index,
    required this.passengerName,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderMealViewModel>(
      builder: (context, viewModel, child) {
        final bool isSelected = viewModel.selectedPassenger == index;

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
                      '${viewModel.getTotalMealCountForPassenger(index)} meal(s)   +${viewModel.getFormattedTotalMealCostForPassenger(index)}',
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

// PassengerSummaryWidget
class PassengerSummaryWidget extends StatelessWidget {
  final PassengerInfoViewModel passengerInfoViewModel;
  final OrderMealViewModel viewModel;

  const PassengerSummaryWidget({
    super.key,
    required this.passengerInfoViewModel,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: SingleChildScrollView(
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
      ),
    );
  }
}

// OrderMealScreen
class OrderMealScreen extends StatefulWidget {
  final FlightData flightData;
  final String routerTrip;
  final String airlineInfo;
  final PassengerInfoViewModel passengerInfoViewModel;
  final AdditionalServicesViewModel additionalServicesViewModel;

  const OrderMealScreen({
    super.key,
    required this.flightData,
    required this.routerTrip,
    required this.airlineInfo,
    required this.passengerInfoViewModel,
    required this.additionalServicesViewModel,
  });

  @override
  _OrderMealScreenState createState() => _OrderMealScreenState();
}

class _OrderMealScreenState extends State<OrderMealScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.passengerInfoViewModel),
        ChangeNotifierProvider(
          create: (_) => OrderMealViewModel(
            flightData: widget.flightData,
            passengerInfoViewModel: widget.passengerInfoViewModel,
            additionalServicesViewModel: widget.additionalServicesViewModel,
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            'ORDER MEAL',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black, size: 16),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<OrderMealViewModel>(
              builder: (context, viewModel, child) {
                if (widget.passengerInfoViewModel.passengers.isEmpty) {
                  return const Center(
                    child: Text(
                      'No passengers found.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PassengerSummaryWidget(
                        passengerInfoViewModel: widget.passengerInfoViewModel,
                        viewModel: viewModel,
                      ),
                      const SizedBox(height: 16),
                      // Hiển thị tên hành khách đang chọn
                      Text(
                        'Add More',
                        style: AppTextStyle.body3.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // Danh sách món ăn chung
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.mealSelections[0]['meals'].length, // Lấy danh sách món ăn từ passenger đầu tiên
                        itemBuilder: (context, mealIndex) {
                          final meal = viewModel.mealSelections[0]['meals'][mealIndex];
                          final quantity = viewModel.selectedPassenger != null
                              ? viewModel.mealSelections[viewModel.selectedPassenger!]['meals'][mealIndex]['quantity'] as int
                              : 0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
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
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      meal['image'],
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(
                                        Icons.fastfood,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          meal['name'],
                                          style: AppTextStyle.paragraph2.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          viewModel.additionalServicesViewModel.formatCurrency(meal['price']),
                                          style: AppTextStyle.caption2.copyWith(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quantity controls with dynamic icon styling
                                  quantity == 0
                                      ? IconButton(
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.blue, // Neutral color when quantity is 0
                                    ),
                                    onPressed: viewModel.selectedPassenger != null
                                        ? () {
                                      viewModel.updateMealQuantity(
                                        mealIndex,
                                        1, // Tăng lên 1
                                      );
                                    }
                                        : null,
                                  )
                                      : Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: AppColors.primaryColor, // Green background when quantity > 0
                                        ),
                                        onPressed: viewModel.selectedPassenger != null
                                            ? () {
                                          viewModel.updateMealQuantity(
                                            mealIndex,
                                            quantity - 1,
                                          );
                                        }
                                            : null,
                                      ),
                                      Text(
                                        '$quantity',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: AppColors.primaryColor, // Green background when quantity > 0
                                        ),
                                        onPressed: viewModel.selectedPassenger != null
                                            ? () {
                                          viewModel.updateMealQuantity(
                                            mealIndex,
                                            quantity + 1, // Tăng số lượng
                                          );
                                        }
                                            : null,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total: ${viewModel.getFormattedTotalMealCost()} VND',
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
                                child: const Text('SELECT'),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}