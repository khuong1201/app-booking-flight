class AdditionalServicesData {
  final String passengerName;
  final String passengerType; // adult, child, infant
  final int passengerAge;
  String? baggagePackage; // Gói hành lý được chọn
  double baggageCost; // Chi phí hành lý
  String? seatSelection; // Ghế được chọn
  double seatCost; // Chi phí ghế
  String? meal; // Bữa ăn được chọn
  double mealCost; // Chi phí bữa ăn
  int mealQuantity; // Số lượng món ăn
  double comprehensiveInsuranceCost; // Chi phí bảo hiểm toàn diện
  double flightDelayInsuranceCost; // Chi phí bảo hiểm trễ chuyến

  AdditionalServicesData({
    required this.passengerName,
    required this.passengerType,
    required this.passengerAge,
    this.baggagePackage,
    this.baggageCost = 0,
    this.seatSelection,
    this.seatCost = 0,
    this.meal,
    this.mealCost = 0,
    this.mealQuantity = 0,
    this.comprehensiveInsuranceCost = 0, // Mặc định 0
    this.flightDelayInsuranceCost = 0, // Mặc định 0
  });

  // Tính tổng chi phí dịch vụ bổ sung cho hành khách
  double get totalCost =>
      baggageCost +
          seatCost +
          mealCost +
          comprehensiveInsuranceCost +
          flightDelayInsuranceCost;

  // Cập nhật gói hành lý
  void updateBaggage(String? package, double cost) {
    baggagePackage = package;
    baggageCost = cost;
  }

  // Cập nhật ghế ngồi
  void updateSeat(String? seat, double cost) {
    seatSelection = seat;
    seatCost = cost;
  }

  // Cập nhật bữa ăn
  void updateMeal(String? meal, double cost, int quantity) {
    this.meal = meal;
    mealCost = cost;
    mealQuantity = quantity;
  }

  // Cập nhật bảo hiểm toàn diện
  void updateComprehensiveInsurance(bool selected, double cost) {
    comprehensiveInsuranceCost = selected ? cost : 0;
  }

  // Cập nhật bảo hiểm trễ chuyến
  void updateFlightDelayInsurance(bool selected, double cost) {
    flightDelayInsuranceCost = selected ? cost : 0;
  }

  // Kiểm tra xem bảo hiểm toàn diện có được chọn không
  bool get hasComprehensiveInsurance => comprehensiveInsuranceCost > 0;

  // Kiểm tra xem bảo hiểm trễ chuyến có được chọn không
  bool get hasFlightDelayInsurance => flightDelayInsuranceCost > 0;

  // Chuyển đổi sang JSON
  Map<String, dynamic> toJson() {
    return {
      'passengerName': passengerName,
      'passengerType': passengerType,
      'passengerAge': passengerAge,
      'baggagePackage': baggagePackage,
      'baggageCost': baggageCost,
      'seatSelection': seatSelection,
      'seatCost': seatCost,
      'meal': meal,
      'mealCost': mealCost,
      'mealQuantity': mealQuantity,
      'comprehensiveInsuranceCost': comprehensiveInsuranceCost,
      'flightDelayInsuranceCost': flightDelayInsuranceCost,
    };
  }
}