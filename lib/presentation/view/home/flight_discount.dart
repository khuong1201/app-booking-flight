import 'package:flutter/material.dart';
import 'flight_card.dart';
import 'package:booking_flight/core/constants/constants.dart';
class FlightDiscount extends StatefulWidget {
  const FlightDiscount({super.key});

  @override
  State<FlightDiscount> createState() => FlightDiscountWidgetState();
}

class FlightDiscountWidgetState extends State<FlightDiscount> {
  bool isOneTrip = true;

  final List<Map<String, String>> flights = [
    {
      "image": "assets/image/KhanhHoa.jpg",
      "route": "Ho Chi Minh - Khanh Hoa",
      "logo" : "assets/logo/vietjet.png",
      "date": "19 April 2025",
      "oldPrice": "1.200.837 VND",
      "newPrice": "938.999 VND",
      "type": "round-trip"
    },
    {
      "image": "assets/image/HaNoi.jpg",
      "route": "Ho Chi Minh - Hanoi",
      "logo" : "assets/logo/vn airlines.png",
      "date": "7 April 2025",
      "oldPrice": "2.800.000 VND",
      "newPrice": "1.900.000 VND",
      "type": "one-way"
    },
    {
      "image": "assets/image/ThuaThienHue.jpg",
      "route": "Da Nang - Thua Thien Hue",
      "logo" : "assets/logo/vn airlines.png",
      "date": "7 April 2025",
      "oldPrice": "1.720.837 VND",
      "newPrice": "1.238.893 VND",
      "type": "round-trip"
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredFlights = flights
        .where((flight) =>
    (isOneTrip && flight["type"] == "one-way") ||
        (!isOneTrip && flight["type"] == "round-trip"))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Flights discount up to 50%",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              buildToggleButton("One - way", true),
              const SizedBox(width: 8),
              buildToggleButton("Round trip", false),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 185,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredFlights.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FlightCard(flight: filteredFlights[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToggleButton(String text, bool value) {
    bool isSelected = isOneTrip == value;
    return GestureDetector(
      onTap: () => setState(() => isOneTrip = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Color(0xFFE6E6E6),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Color(0xFFE6E6E6) : AppColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.21,
          ),
        ),
      ),
    );
  }
}
