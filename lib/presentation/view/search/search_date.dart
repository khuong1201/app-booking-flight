import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widget/app_bar_choose_date_widget.dart';
import '../../viewmodel/searchmodel/selection_date_view_model.dart';

class SelectionDate extends StatelessWidget {
  const SelectionDate({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectionDateViewModel(),
      child: Consumer<SelectionDateViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBarChooseDateWidget(
              onBack: () => Navigator.pop(context),
              departingDate: viewModel.departingDate != null
                  ? DateFormat('EEE, MMM d yyyy').format(viewModel.departingDate!)
                  : "Departing Date", // Hiển thị ngày đi hoặc "Departing Date"
              returningDate: viewModel.returningDate != null
                  ? DateFormat('EEE, MMM d yyyy').format(viewModel.returningDate!)
                  : "Returning Date", // Hiển thị ngày về hoặc "Returning Date"
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
                        .toList(), // Hiển thị các ngày trong tuần
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.months.length,
                    itemBuilder: (context, index) {
                      return MonthView(
                        currentMonth: viewModel.months[index],
                        departingDate: viewModel.departingDate,
                        returningDate: viewModel.returningDate,
                        onDateSelected: viewModel.onDateSelected,
                      ); // Hiển thị lịch theo tháng
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: viewModel.departingDate != null &&
                        viewModel.returningDate != null
                        ? () {
                      Navigator.pop(context, {
                        'departingDate': viewModel.departingDate,
                        'returningDate': viewModel.returningDate,
                      });
                    }
                        : null, // Cho phép chọn khi cả ngày đi và về đã được chọn
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(350, 40),
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                    ),
                    child: const Text(
                      'Select',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF2F2F2),
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
          ), // Hiển thị tên tháng và năm
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
            ); // Hiển thị các ô ngày
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
    firstWeekday = firstWeekday == 7 ? 0 : firstWeekday;

    for (int i = 0; i < firstWeekday; i++) {
      dates.add(DateTime(0)); // Thêm các ô trống để căn chỉnh lịch
    }

    dates.addAll(List.generate(daysInMonth, (i) {
      return DateTime(currentMonth.year, currentMonth.month, i + 1);
    })); // Thêm các ngày trong tháng

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
      textColor = const Color(0xFFE6E6E6); // Màu sắc cho ngày đi và về
    } else if (isBetween) {
      backgroundColor = const Color(0xFFC8D1F0);
      textColor = AppColors.neutralColor; // Màu sắc cho ngày giữa đi và về
    } else if (isPast) {
      textColor = const Color(0xFF9C9C9C); // Màu sắc cho ngày quá khứ
    }

    BorderRadius borderRadius;
    if (isDeparting) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(50),
        bottomLeft: Radius.circular(50),
      );
    } else if (isReturning) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(50),
        bottomRight: Radius.circular(50),
      );
    } else {
      borderRadius = BorderRadius.zero; // Hình dạng ô ngày
    }

    return GestureDetector(
      onTap: date.year != 0 ? () => onDateSelected(date) : null, // Cho phép chọn nếu ngày hợp lệ
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
        ), // Hiển thị số ngày
      )
          : const SizedBox(), // Ô trống nếu ngày không hợp lệ
    );
  }
}