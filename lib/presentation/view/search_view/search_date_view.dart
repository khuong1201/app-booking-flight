import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../viewmodel/search_viewmodel/selection_date_view_model.dart';

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
                  _buildDateSelector(departingDate, onDepartingDateChanged, context),
                  const SizedBox(width: 40),
                  Image.asset(
                    'assets/icons/Vector.png',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 40),
                  _buildDateSelector(returningDate, onReturningDateChanged, context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(String date, Function(String) onDateChanged, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedDates = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SelectionDate(isRoundTrip: true),
          ),
        );

        if (selectedDates is Map<String, DateTime?>) {
          if (selectedDates['departingDate'] != null) {
            onDateChanged(
              DateFormat('EEE, MMM d, y').format(selectedDates['departingDate']!),
            );
          }
        }
      },
      child: Text(
        date,
        style: AppTextStyle.paragraph1.copyWith(
          color: Colors.grey.withOpacity(0.6),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class SelectionDate extends StatelessWidget {
  final bool isRoundTrip;

  const SelectionDate({super.key, required this.isRoundTrip});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectionDateViewModel(isRoundTrip: isRoundTrip),
      child: Consumer<SelectionDateViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBarChooseDateWidget(
              onBack: () => Navigator.pop(context),
              departingDate: viewModel.departingDate != null
                  ? DateFormat('EEE, MMM d yyyy').format(viewModel.departingDate!)
                  : "Departing Date",
              returningDate: viewModel.returningDate != null
                  ? DateFormat('EEE, MMM d yyyy').format(viewModel.returningDate!)
                  : "Returning Date",
              onDepartingDateChanged: viewModel.updateDepartingDate,
              onReturningDateChanged: viewModel.updateReturningDate,
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color(0xFFE3E8F7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                        .map((day) => Text(
                      day,
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.months.length,
                    itemBuilder: (context, index) {
                      DateTime month = viewModel.months[index];
                      return MonthView(
                        currentMonth: month,
                        departingDate: viewModel.departingDate,
                        returningDate: viewModel.returningDate,
                        onDateSelected: (date) {
                          viewModel.onDateSelected(date);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        if (viewModel.departingDate != null) {
                          Navigator.pop(context, {
                            'departingDate': viewModel.departingDate,
                            'returningDate': viewModel.returningDate,
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(300, 25),
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Select Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF2F2F2),
                          fontFamily: 'Poppins',
                        ),
                      ),
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

class MonthView extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime? departingDate;
  final DateTime? returningDate;
  final Function(DateTime) onDateSelected;

  const MonthView({
    super.key,
    required this.currentMonth,
    required this.departingDate,
    required this.returningDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    String monthFormatted = DateFormat('MMMM y').format(currentMonth);
    List<DateTime> dates = _generateDates(currentMonth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            monthFormatted,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.all(10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 1.2,
          ),
          itemCount: dates.length,
          itemBuilder: (context, dateIndex) {
            return DateCell(
              date: dates[dateIndex],
              departingDate: departingDate,
              returningDate: returningDate,
              onDateSelected: onDateSelected,
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  List<DateTime> _generateDates(DateTime currentMonth) {
    List<DateTime> dates = [];
    int daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    int firstWeekday = DateTime(currentMonth.year, currentMonth.month, 1).weekday;
    firstWeekday = firstWeekday - 1;
    for (int i = 0; i < firstWeekday; i++) {
      dates.add(DateTime(0));
    }

    dates.addAll(List.generate(daysInMonth, (i) {
      return DateTime(currentMonth.year, currentMonth.month, i + 1);
    }));

    return dates;
  }
}

class DateCell extends StatelessWidget {
  final DateTime date;
  final DateTime? departingDate;
  final DateTime? returningDate;
  final Function(DateTime) onDateSelected;

  const DateCell({
    super.key,
    required this.date,
    required this.departingDate,
    required this.returningDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isDeparting = departingDate != null && date.isAtSameMomentAs(departingDate!);
    bool isReturning = returningDate != null && date.isAtSameMomentAs(returningDate!);
    bool isBetween = departingDate != null && returningDate != null &&
        date.isAfter(departingDate!) && date.isBefore(returningDate!);
    bool isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

    Color backgroundColor = Colors.transparent;
    Color textColor = Colors.black;

    if (isDeparting || isReturning) {
      backgroundColor = AppColors.primaryColor;
      textColor = const Color(0xFFE6E6E6);
    } else if (isBetween) {
      backgroundColor = const Color(0xFFC8D1F0);
      textColor = AppColors.neutralColor;
    } else if (isPast) {
      textColor = const Color(0xFF9C9C9C);
    }

    BorderRadius borderRadius;
    if (isDeparting && returningDate == null) {
      borderRadius = BorderRadius.circular(50);
    } else if (isReturning && departingDate != null) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(50),
        bottomRight: Radius.circular(50),
      );
    } else if (isDeparting && returningDate != null) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(50),
        bottomLeft: Radius.circular(50),
      );
    } else {
      borderRadius = BorderRadius.zero;
    }

    return GestureDetector(
      onTap: date.year != 0 && !isPast
          ? () => onDateSelected(date) // Gọi callback để chọn hoặc bỏ chọn
          : null,
      child: date.year != 0
          ? Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Text(
          DateFormat('d').format(date),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      )
          : const SizedBox(),
    );
  }
}

