import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/constants.dart';
import '../../viewmodel/searchmodel/search_passenger_view_model.dart';

class PassengerSelectionSheet extends StatelessWidget {
  final int initialAdults;
  final int initialChilds;
  final int initialInfants;

  const PassengerSelectionSheet({
    super.key,
    this.initialAdults = 1,
    this.initialChilds = 0,
    this.initialInfants = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PassengerSelectionViewModel(
        initialAdults: initialAdults,
        initialChildren: initialChilds,
        initialInfants: initialInfants,
      ),
      child: Consumer<PassengerSelectionViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildHandleBar(),
                Text("NUMBER OF PASSENGER", style: AppTextStyle.heading4),
                const Divider(thickness: 1),
                const SizedBox(height: 16),
                buildCounter("Adult", "Age 12+", viewModel.adultCount, viewModel.updateAdultCount),
                buildCounter("Child", "Age 2 - 11", viewModel.childCount, viewModel.updateChildCount),
                buildCounter("Infant", "Below age 2", viewModel.infantCount, viewModel.updateInfantCount),
                const SizedBox(height: 16),
                buildActionButtons(context, viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildHandleBar() => Center(
    child: Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  Widget buildCounter(String label, String subLabel, int count, Function(int) onUpdate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(subLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Row(
            children: [
              buildCounterButton(Icons.remove, count > 0 ? () => onUpdate(count - 1) : null, const Color(0xFFD3D3D3)),
              buildCounterDisplay(count),
              buildCounterButton(Icons.add, () => onUpdate(count + 1), const Color(0xFFA3B2E4)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCounterButton(IconData icon, VoidCallback? onPressed, Color bgColor) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.zero,
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        minimumSize: const Size(40, 40),
      ),
      child: Icon(icon, color: AppColors.primaryColor, size: 20),
    );
  }

  Widget buildCounterDisplay(int count) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        count.toString(),
        style: AppTextStyle.body1,
      ),
    );
  }

  Widget buildActionButtons(BuildContext context, PassengerSelectionViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildActionButton(
          label: "Cancel",
          color: const Color(0xFFF2F2F2),
          textColor: AppColors.primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 16),
        buildActionButton(
          label: "Select",
          color: AppColors.primaryColor,
          textColor: const Color(0xFFF2F2F2),
          onPressed: () {
            String? error = viewModel.validatePassengers();
            if (error == null) {
              Navigator.pop(context, viewModel.getPassengerSelection());
            } else {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Lỗi"),
                  content: Text(error),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget buildActionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        minimumSize: const Size(164, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: textColor,
        ),
      ),
    );
  }
}
