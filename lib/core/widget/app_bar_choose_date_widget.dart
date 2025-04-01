import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:booking_flight/core/constants/constants.dart';
import '../../presentation/view/search/search_date.dart';

class AppBarChooseDateWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final String departingDate;
  final String returningDate;
  final Function(String) onDepartingDateChanged;
  final Function(String) onReturningDateChanged;

  const AppBarChooseDateWidget({
    required this.onBack,
    this.departingDate = 'Departing Date',
    this.returningDate = 'Returning Date',
    required this.onDepartingDateChanged,
    required this.onReturningDateChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: onBack,
                    ),
                  const SizedBox(width: 90),
                  Text(
                    "Choose date",
                    style: AppTextStyle.heading4.copyWith(
                      color: const Color(0xFFF2F2F2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // Điều hướng đến SelectionDate
                      final selectedDates = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectionDate(),
                        ),
                      );

                      if (selectedDates is Map<String, DateTime?>) {
                        if (selectedDates['departingDate'] != null) {
                          onDepartingDateChanged(
                            DateFormat('EEE, MMM d, y').format(selectedDates['departingDate']!),
                          );
                        }
                      }
                    },
                    child: Text(
                      departingDate,
                      style: AppTextStyle.paragraph1.copyWith(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Image.asset(
                    'assets/icons/Vector.png',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 40),
                  GestureDetector(
                    onTap: () async {
                      // Điều hướng đến SelectionDate
                      final selectedDates = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectionDate(),
                        ),
                      );

                      if (selectedDates is Map<String, DateTime?>) {
                        if (selectedDates['returningDate'] != null) {
                          onReturningDateChanged(
                            DateFormat('EEE, MMM d, y').format(selectedDates['returningDate']!),
                          );
                        }
                      }
                    },
                    child: Text(
                      returningDate,
                      style: AppTextStyle.paragraph1.copyWith(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}