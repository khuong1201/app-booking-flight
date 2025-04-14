import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';
import 'package:intl/intl.dart';
import '../../../data/search_flight_Data.dart';
import '../../viewmodel/searchmodel/search_flight_tiket_view_model.dart';

// FlightTicketCard Widget
class FlightTicketCard extends StatelessWidget {
  final FlightTicketViewModel viewModel;
  final bool isBestCheap;
  const FlightTicketCard({super.key, required this.viewModel, this.isBestCheap = false,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 379,
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isBestCheap ? AppColors.secondaryColor : Color(0xFF9C9C9C), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to fill width
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between elements
            children: [
              Image.asset(
                viewModel.airlineLogo,
                height: 30,
                width: 30,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.airplane_ticket, size: 30),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between
                      children: [
                        buildFlightTimeColumn(
                            viewModel.departureTime,
                            viewModel.departureAirport,
                            CrossAxisAlignment.start),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(viewModel.duration,
                                style: TextStyle(
                                    color: Color(0xFF9C9C9C), fontSize: 12)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 1,
                                  width: 60,
                                  color: Color(0xFF9C9C9C),
                                ),
                                SizedBox(width: 2),
                                Transform.scale(
                                  scaleX: 2.0,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 8,
                                    color: Color(0xFF9C9C9C),
                                  ),
                                ),
                              ],
                            ),
                            Text('Direct',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF9C9C9C),
                                )),
                          ],
                        ),
                        buildFlightTimeColumn(
                            viewModel.arrivalTime,
                            viewModel.arrivalAirport,
                            CrossAxisAlignment.end),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Container(
                height: 40,
                width: 1,
                color: Color(0xFF9C9C9C),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end, // Align to the end
                children: [
                  Text(viewModel.price,
                      style: AppTextStyle.body3.copyWith(color: AppColors.secondaryColor)),
                  Text(viewModel.passengerCount,
                      style: TextStyle(color: Color(0xFF9C9C9C), fontSize: 12)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between
            children: [
              Text(viewModel.airlineName,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Details",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  SizedBox(width: 5),
                  Icon(Icons.error_outline, color: Colors.red, size: 14),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFlightTimeColumn(
      String time, String airport, CrossAxisAlignment alignment) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        Text(time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(airport, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

// FlightTicketScreen Widget
class FlightTicketScreen extends StatefulWidget {
  final String departureAirport;
  final String arrivalAirport;
  final String departureDate;
  final String returnDate;
  final int passengers;
  final String seatClass;

  const FlightTicketScreen({
    super.key,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureDate,
    required this.returnDate,
    required this.passengers,
    required this.seatClass,
  });

  @override
  State<FlightTicketScreen> createState() => _FlightTicketScreenState();
}

class _FlightTicketScreenState extends State<FlightTicketScreen> {
  late List<FlightTicketViewModel> viewModelList;
  late List<FlightTicketViewModel> filteredList;
  FlightTicketViewModel? cheapestFlight;

  @override
  void initState() {
    super.initState();
    // Fetch data based on the inputs from the previous screen
    viewModelList = FlightTicketViewModel.fetchAllData(flightDataList);
    filteredList = List.from(viewModelList);
    cheapestFlight = FlightTicketViewModel.findCheapestFlight(viewModelList); // Find the cheapest flight
    filterFlights(); // Filter the data based on the passed parameters
  }

  void filterFlights() {
    print('Filtering flights...');
    filteredList = FlightTicketViewModel.filterFlights(
      flights: viewModelList,
      departureCode: widget.departureAirport,
      arrivalCode: widget.arrivalAirport,
      date: widget.departureDate,
    );
    print('Filtered flights: ${filteredList.length}');
    setState(() {}); // Update UI after filtering
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDepartureDate = DateTime.parse(widget.departureDate);
    String formattedDepartureDate = DateFormat('EEE, d MMM ').format(parsedDepartureDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.departureAirport,
                  style: AppTextStyle.paragraph2.copyWith(color: const Color(0xFFF2F2F2)),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/icons/Airplane.png',
                  width: 16,
                  height: 16,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.arrivalAirport,
                  style: AppTextStyle.paragraph2.copyWith(color: const Color(0xFFF2F2F2)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "$formattedDepartureDate. ${widget.passengers} pax. ${widget.seatClass}",
                  style: AppTextStyle.caption1.copyWith(color: Color(0xFFD3D3D3)),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Nếu có chuyến bay rẻ nhất
          if (cheapestFlight != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 14.0, top: 10.0, bottom: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Best flight from your search',
                  style: AppTextStyle.paragraph2,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            FlightTicketCard(viewModel: cheapestFlight!, isBestCheap: true),
          ],

          // Nếu có danh sách chuyến bay lọc
          if (filteredList.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 14.0, top: 10.0, bottom: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'All flight',
                  style: AppTextStyle.paragraph2,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            ListView.builder(
              itemCount: filteredList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return FlightTicketCard(viewModel: filteredList[index]);
              },
            ),
          ],

          // Nếu KHÔNG có best flight và cũng không có danh sách chuyến bay
          if (cheapestFlight == null && filteredList.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  'No flights available',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}



