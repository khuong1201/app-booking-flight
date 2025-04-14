import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_flight/core/constants/constants.dart';
import '../../viewmodel/home/flight_cart_view_model.dart';

class FlightCard extends StatelessWidget {
  final Map<String, String> flight;

  const FlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FlightCardViewModel(flight),
      child: Consumer<FlightCardViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1A000000),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              children: [
                /// Ảnh đại diện chuyến bay
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  child: Image.asset(
                    viewModel.image,
                    height: 87,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 4),
                /// Phần thông tin chuyến bay
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Lộ trình chuyến bay
                        if (viewModel.hasRoute)
                          Text(viewModel.route, style: AppTextStyle.caption1),
                        const SizedBox(height: 4),
                        /// Logo hãng bay + ngày bay
                        Row(
                          children: [
                            if (viewModel.hasLogo)
                              Image.asset(viewModel.logo, width: 26, height: 16, fit: BoxFit.cover),
                            const SizedBox(width: 4),
                            Text(viewModel.date, style: AppTextStyle.caption2),
                          ],
                        ),
                        const SizedBox(height: 4),
                        /// Giá chuyến bay
                        if (viewModel.newPrice.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (viewModel.hasOldPrice)
                                Text(
                                  viewModel.oldPrice!,
                                  style: AppTextStyle.caption1.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.neutralColor,
                                    fontSize: 9,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                viewModel.newPrice,
                                style: AppTextStyle.paragraph2.copyWith(
                                  color: AppColors.semanticColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
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
