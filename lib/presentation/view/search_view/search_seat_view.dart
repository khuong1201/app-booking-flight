import 'package:booking_flight/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/seat_class_model.dart';
import '../../viewmodel/search_viewmodel/search_seat_view_model.dart';


class SeatSelectionSheet extends StatelessWidget {
  const SeatSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SeatSelectionViewModel(),
      child: Consumer<SeatSelectionViewModel>(
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
                buildDragIndicator(),
                Text("SEAT CLASS", style: AppTextStyle.body3),
                const Divider(height: 3, thickness: 1),
                const SizedBox(height: 8),
                SeatClassSelection(
                  selectedClass: viewModel.selectedClass,
                  onClassSelected: viewModel.updateSelectedClass,
                  seatClasses: viewModel.seatClasses,
                ),
                const SizedBox(height: 8),
                buildDoneButton(context, viewModel.selectedClass),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDragIndicator() {
    return Center(
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
  }

  Widget buildDoneButton(BuildContext context, String selectedClass) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context, selectedClass),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(343, 48),
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text("Done", style: AppTextStyle.heading4.copyWith(color: const Color(0xFFF2F2F2))),
    );
  }
}

class SeatClassSelection extends StatelessWidget {
  final String selectedClass;
  final ValueChanged<String> onClassSelected;
  final List<SeatClass> seatClasses;

  const SeatClassSelection({
    super.key,
    required this.selectedClass,
    required this.onClassSelected,
    required this.seatClasses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: seatClasses.map((seatClass) => buildRadioTile(context, seatClass)).toList(),
    );
  }

  Widget buildRadioTile(BuildContext context, SeatClass seatClass) {
    return Consumer<SeatSelectionViewModel>(
      builder: (context, viewModel, child) {
        return RadioListTile<String>(
          value: seatClass.value,
          groupValue: viewModel.selectedClass,
          onChanged: (String? newValue) {
            if (newValue != null) {
              viewModel.updateSelectedClass(newValue);
            }
          },
          title: Text(seatClass.title, style: textStyle(14)),
          subtitle: Text(seatClass.subtitle, style: textStyle(10)),
          activeColor: AppColors.primaryColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          visualDensity: const VisualDensity(vertical: -4),
        );
      },
    );
  }

  TextStyle textStyle(double size) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w400,
      fontFamily: 'Poppins',
      color: Colors.black,
    );
  }
}