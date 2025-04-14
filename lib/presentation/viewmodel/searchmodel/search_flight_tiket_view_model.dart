import '../../../data/search_flight_Data.dart';
import 'package:flutter/foundation.dart';

class FlightTicketViewModel extends ChangeNotifier {
  FlightData flightData;

  FlightTicketViewModel(this.flightData);

  String get airlineLogo => flightData.airlineLogo;
  String get airlineName => flightData.airlineName;
  String get departureTime => flightData.departureTime;
  String get departureAirport => flightData.departureAirport;
  String get arrivalTime => flightData.arrivalTime;
  String get arrivalAirport => flightData.arrivalAirport;
  String get duration => flightData.duration;
  String get price => flightData.price;
  String get passengerCount => flightData.passengerCount;
  String get departureDate => flightData.departureDate;

  void updateFlightData(FlightData newFlightData) {
    flightData = newFlightData;
    notifyListeners();
  }

  static List<FlightTicketViewModel> fetchAllData(List<FlightData> flightDataList) {
    return flightDataList.map((data) => FlightTicketViewModel(data)).toList();
  }

  static List<FlightTicketViewModel> filterFlights({
    required List<FlightTicketViewModel> flights,
    required String departureCode,
    required String arrivalCode,
    required String date, // Ensure this is the correct format (yyyy-MM-dd)
  }) {
    List<FlightTicketViewModel> filteredFlights = flights.where((flight) {
      // Hàm trích xuất mã sân bay từ tên sân bay
      String extractAirportCode(String airportInfo) {
        RegExp regExp = RegExp(r'\((.*?)\)');  // Biểu thức chính quy để lấy mã sân bay trong dấu ngoặc
        Match? match = regExp.firstMatch(airportInfo);
        return match?.group(1) ?? '';  // Trả về mã sân bay bên trong dấu ngoặc
      }

      // Trích xuất mã sân bay từ departureAirport và arrivalAirport
      String departureAirportCode = extractAirportCode(departureCode);
      String arrivalAirportCode = extractAirportCode(arrivalCode);
      // Kiểm tra xem mã sân bay có khớp với mã đầu vào không
      bool matchesDeparture = flight.departureAirport == departureAirportCode;
      bool matchesArrival = flight.arrivalAirport == arrivalAirportCode;

      // Chuyển đổi cả hai ngày thành DateTime để so sánh chính xác
      DateTime flightDate = DateTime.parse(flight.departureDate);  // Chuyển đổi ngày của chuyến bay thành DateTime
      DateTime filterDate = DateTime.parse(date);  // Chuyển đổi ngày lọc thành DateTime

      bool matchesDate = flightDate.isAtSameMomentAs(filterDate);  // Kiểm tra nếu ngày khớp

      // Trả về chuyến bay nếu tất cả điều kiện khớp
      return matchesDeparture && matchesArrival && matchesDate;
    }).toList();

    // Log số lượng chuyến bay sau khi lọc
    print("Filtered flights count: ${filteredFlights.length}");

    return filteredFlights;
  }

  // Phương thức tìm chuyến bay có giá rẻ nhất
  static FlightTicketViewModel? findCheapestFlight(List<FlightTicketViewModel> flights) {
    if (flights.isEmpty) return null;  // Nếu không có chuyến bay nào, trả về null

    // Sắp xếp các chuyến bay theo giá vé (từ thấp đến cao)
    flights.sort((a, b) {
      double priceA = double.tryParse(a.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? double.infinity;
      double priceB = double.tryParse(b.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? double.infinity;
      return priceA.compareTo(priceB);
    });

    // Trả về chuyến bay có giá vé thấp nhất
    return flights.first;
  }
}
