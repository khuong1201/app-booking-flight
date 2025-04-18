import 'package:flutter/material.dart';
import '../../view/home/Detail_flight_tickets.dart';
import '../home/Detail_flight_tickets_view_model.dart'; // Đảm bảo rằng import đúng

class AdditionalServicesViewModel extends ChangeNotifier {
  bool _comprehensiveInsurance = true;
  bool _flightDelayInsurance = false;
  double _totalAmount = 1634600;

  bool get comprehensiveInsurance => _comprehensiveInsurance;
  bool get flightDelayInsurance => _flightDelayInsurance;
  double get totalAmount => _totalAmount;

  void toggleComprehensiveInsurance(bool value) {
    _comprehensiveInsurance = value;
    _updateTotal();
    notifyListeners();
  }

  void toggleFlightDelayInsurance(bool value) {
    _flightDelayInsurance = value;
    _updateTotal();
    notifyListeners();
  }

  void _updateTotal() {
    _totalAmount = 1564600 +
        (_comprehensiveInsurance ? 35000 : 0) +
        (_flightDelayInsurance ? 35000 : 0);
  }

  void addService(String service) {
    notifyListeners();
  }

  void continueAction() {
    // Logic khi nhấn nút Continue, ví dụ: điều hướng hoặc gửi dữ liệu
    print("Continue pressed with total: $_totalAmount VND");
  }

  Future<void> showTicketDetailsSheet(BuildContext context, dynamic searchTicketData, dynamic flightData) async {
    final detailViewModel = DetailFlightTicketsViewModel(
      searchTicketData: searchTicketData,
      flightData: flightData,
    );

    // Hiển thị BottomSheet với TicketDetailsView
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TicketDetailsView(
                  viewModel: detailViewModel,
                  onClose: () {
                    Navigator.pop(context); // Đóng bottom sheet
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
