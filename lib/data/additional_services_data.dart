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
  });

  // Tính tổng chi phí dịch vụ bổ sung cho hành khách
  double get totalCost => baggageCost + seatCost + mealCost;

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
  void updateMeal(String? meal, double cost) {
    this.meal = meal;
    mealCost = cost;
  }
}