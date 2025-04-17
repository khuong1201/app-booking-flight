import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../core/widget/tab_bar_widget.dart';
import '../../../data/search_flight_Data.dart';
import '../../../data/search_tickets_tmp_data.dart';
import '../../viewmodel/searchmodel/search_flight_tiket_view_model.dart';
import '../home/one_way_trip_form_view.dart';
import '../home/round_trip_form_view.dart';

class FlightTicketCard extends StatelessWidget {
  final FlightTicketViewModel viewModel;
  final bool isBestCheap;
  const FlightTicketCard({
    super.key,
    required this.viewModel,
    this.isBestCheap = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 379,
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isBestCheap ? AppColors.secondaryColor : Color(0xFF9C9C9C),
            width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    fontWeight: FontWeight.normal)),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(viewModel.price,
                      style: AppTextStyle.body3
                          .copyWith(color: AppColors.secondaryColor)),
                  Text(viewModel.passengerCount,
                      style:
                      TextStyle(color: Color(0xFF9C9C9C), fontSize: 12)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
  final int passengerAdults;
  final int passengerChilds;
  final int passengerInfants;

  const FlightTicketScreen({
    super.key,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureDate,
    required this.returnDate,
    required this.passengers,
    required this.seatClass,
    required this.passengerAdults,
    required this.passengerChilds,
    required this.passengerInfants,
  });

  @override
  State<FlightTicketScreen> createState() => _FlightTicketScreenState();
}

class _FlightTicketScreenState extends State<FlightTicketScreen> {
  late SearchTicketsTemp currentSearchData;
  late List<FlightTicketViewModel> allViewModelList;
  late List<FlightTicketViewModel> filteredList;
  FlightTicketViewModel? cheapestFlight;
  bool isLoading = true;
  int _tabIndex = 0; // State for the tab bar

  @override
  void initState() {
    super.initState();
    _initializeAndFilterFlights();
  }

  String _extractCode(String airportInfo) {
    RegExp regExp = RegExp(r'\((.*?)\)');
    Match? match = regExp.firstMatch(airportInfo);
    return match?.group(1) ?? airportInfo;
  }

  void _initializeAndFilterFlights() {
    setState(() => isLoading = true);
    currentSearchData = SearchTicketsTemp(
      departureAirportCode: _extractCode(widget.departureAirport),
      arrivalAirportCode: _extractCode(widget.arrivalAirport),
      departingDate: widget.departureDate,
      returningDate:
      widget.returnDate.isNotEmpty ? widget.returnDate : null,
      passengerAdults: widget.passengerAdults,
      passengerChilds: widget.passengerChilds,
      passengerInfants: widget.passengerInfants,
      seatClass: widget.seatClass,
      isRoundTrip: widget.returnDate.isNotEmpty,
    );

    allViewModelList =
        FlightTicketViewModel.fetchAllData(flightDataList, currentSearchData);

    print(
        'Filtering flights for: ${widget.departureAirport} -> ${widget.arrivalAirport} on ${widget.departureDate}');
    filteredList = FlightTicketViewModel.filterFlights(
      flights: allViewModelList,
      departureInfo: widget.departureAirport,
      arrivalInfo: widget.arrivalAirport,
      date: widget.departureDate,
    );
    print('Found ${filteredList.length} matching flights.');

    cheapestFlight =
        FlightTicketViewModel.findCheapestFlight(filteredList);

    setState(() => isLoading = false);
  }

  void _showSearchOptionsDialog(BuildContext context) {
    int localTabIndex = _tabIndex;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(top: 0, left: 0, right: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                color: AppColors.primaryColor, // Màu nền của toàn bộ dialog
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Search new flight',
                          style: AppTextStyle.paragraph2.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Màu nền của CustomTabBar
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CustomTabBar(
                              currentIndex: localTabIndex,
                              onTap: (index) {
                                setModalState(() {
                                  localTabIndex = index;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: IndexedStack(
                              index: localTabIndex,
                              children: const [
                                RoundTripForm(),
                                OneWayTripForm(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    String formattedDepartureDate = "Date Error";
    try {
      DateTime parsedDepartureDate = DateTime.parse(widget.departureDate);
      formattedDepartureDate =
          DateFormat('EEE, d MMM').format(parsedDepartureDate);
    } catch (e) {
      print("Error parsing widget.departureDate: ${widget.departureDate}");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: 72,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    "${currentSearchData.departureAirportCode ?? 'N/A'}  →  ${currentSearchData.arrivalAirportCode ?? 'N/A'}",
                    style: AppTextStyle.paragraph2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    "$formattedDepartureDate, ${widget.passengers} pax, ${widget.seatClass}",
                    style:
                    AppTextStyle.caption1.copyWith(color: Color(0xFFE0E0E0)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    _showSearchOptionsDialog(context);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/material-symbols-light_arrow-drop-down-rounded.svg',
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildFlightList(),
    );
  }

  Widget _buildFlightList() {
    if (filteredList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'No flights found matching your criteria.\nPlease try different dates or airports.',
            textAlign: TextAlign.center,
            style: AppTextStyle.paragraph1.copyWith(color: Colors.grey[700]),
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.only(top: 8),
      children: [
        if (cheapestFlight != null) ...[
          Padding(
            padding:
            const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 4.0),
            child: Text(
              'Best flight from your search',
              style: AppTextStyle.paragraph1.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () {
              cheapestFlight!.showTicketDetailsSheet(context);
            },
            child: FlightTicketCard(
                viewModel: cheapestFlight!, isBestCheap: true),
          ),
          Divider(indent: 16, endIndent: 16, height: 20),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 4.0),
          child: Text(
            cheapestFlight != null ? 'All flights' : 'Available flights',
            style: AppTextStyle.paragraph1.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ...filteredList
            .map((flight) => GestureDetector(
          onTap: () {
            flight.showTicketDetailsSheet(context);
          },
          child:
          FlightTicketCard(viewModel: flight, isBestCheap: false),
        ))
            .toList(),
        SizedBox(height: 20),
      ],
    );
  }
}