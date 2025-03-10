import 'package:flutter/material.dart';

class BookingFlightScreen extends StatefulWidget {
  const BookingFlightScreen({Key? key}) : super(key: key);

  @override
  BookingFlightScreenState createState() => BookingFlightScreenState();
}

class BookingFlightScreenState extends State<BookingFlightScreen> {
  bool isRoundTrip = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Flight"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: const BoxDecoration(
              color: Color(0xFF283593),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/logo/Primiter.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // Sử dụng Stack để xếp chồng ChoiceChip
                  SizedBox(
                    height: 50, // Điều chỉnh chiều cao tùy ý
                    child: Stack(
                      children: [
                        // ChoiceChip "Round Trip"
                        Positioned(
                          left: 0,
                          child: ChoiceChip(
                            label: const Text("Round Trip"),
                            selected: isRoundTrip,
                            onSelected: (selected) {
                              setState(() {
                                isRoundTrip = true;
                              });
                            },
                            selectedColor: Colors.blue[200],
                          ),
                        ),

                        // ChoiceChip "One-Way"
                        Positioned(
                          right: 0,
                          child: ChoiceChip(
                            label: const Text("One-Way"),
                            selected: !isRoundTrip,
                            onSelected: (selected) {
                              setState(() {
                                isRoundTrip = false;
                              });
                            },
                            selectedColor: Colors.blue[200],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 20, thickness: 1),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "From",
                      prefixIcon: Icon(Icons.flight_takeoff),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(height: 20, thickness: 1),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "To",
                      prefixIcon: Icon(Icons.flight_land),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(height: 20, thickness: 1),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Departure Date",
                      prefixIcon: Icon(Icons.calendar_today),
                      border: InputBorder.none,
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        setState(() {
                          // Cập nhật giá trị của trường Departure Date (nếu cần)
                        });
                      }
                    },
                  ),
                  if (isRoundTrip) ...[
                    const Divider(height: 20, thickness: 1),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Return Date",
                        prefixIcon: Icon(Icons.calendar_today),
                        border: InputBorder.none,
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          setState(() {
                            // Cập nhật giá trị của trường Return Date (nếu cần)
                          });
                        }
                      },
                    ),
                  ],
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Search Flights",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}