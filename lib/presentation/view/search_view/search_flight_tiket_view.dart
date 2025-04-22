import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:booking_flight/core/constants/constants.dart';
import 'package:booking_flight/core/widget/tab_bar_widget.dart';
import 'package:booking_flight/data/SearchViewModel.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/view/home/one_way_trip_form_view.dart';
import 'package:booking_flight/presentation/view/home/round_trip_form_view.dart';
import 'package:booking_flight/presentation/viewmodel/home/one_way_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/home/round_trip_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/search_flight_tiket_view_model.dart';

// FlightTicketCard Widget
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isBestCheap ? AppColors.secondaryColor : Colors.grey,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                viewModel.airlineLogo,
                height: 30,
                width: 30,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.airplane_ticket),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFlightInfo(viewModel.departureTime, viewModel.departureAirport),
                    _buildFlightDuration(viewModel.duration),
                    _buildFlightInfo(viewModel.arrivalTime, viewModel.arrivalAirport),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    viewModel.price,
                    style: const TextStyle(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    viewModel.passengerCount.isNotEmpty ? viewModel.passengerCount : '1',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                viewModel.airlineName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => viewModel.showTicketDetailsSheet(context),
                child: const Text(
                  'Details',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightInfo(String time, String airport) {
    return Column(
      children: [
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(airport, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildFlightDuration(String duration) {
    return Column(
      children: [
        Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Row(
          children: [
            Container(width: 40, height: 1, color: Colors.grey),
            const Icon(Icons.arrow_forward, size: 12, color: Colors.grey),
          ],
        ),
        const Text('Direct', style: TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}

// FlightTicketScreen Widget
class FlightTicketScreen extends StatefulWidget {
  final SearchViewModel searchViewModel;

  const FlightTicketScreen({
    super.key,
    required this.searchViewModel,
  });

  @override
  State<FlightTicketScreen> createState() => _FlightTicketScreenState();
}

class _FlightTicketScreenState extends State<FlightTicketScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FlightTicketViewModel>(context, listen: false).fetchFlights();
    });
  }

  String _extractCode(Map<String, dynamic>? airport) {
    return airport?['code']?.toString() ?? '';
  }

  String _getSeatClass() {
    if (widget.searchViewModel is OneWayTripViewModel) {
      return (widget.searchViewModel as OneWayTripViewModel).seatClass;
    } else if (widget.searchViewModel is RoundTripFormViewModel) {
      return (widget.searchViewModel as RoundTripFormViewModel).seatClass;
    }
    return 'Economy';
  }

  void _showSearchOptionsDialog(BuildContext context) {
    int tabIndex = 0;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: AppColors.primaryColor,
                    padding: const EdgeInsets.all(16),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Search new flight',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomTabBar(
                            currentIndex: tabIndex,
                            onTap: (index) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setModalState(() {
                                  tabIndex = index;
                                });
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: IndexedStack(
                            index: tabIndex,
                            children: [
                              ChangeNotifierProvider<RoundTripFormViewModel>(
                                create: (_) => widget.searchViewModel is RoundTripFormViewModel
                                    ? widget.searchViewModel as RoundTripFormViewModel
                                    : RoundTripFormViewModel(),
                                child: const RoundTripForm(),
                              ),
                              ChangeNotifierProvider<OneWayTripViewModel>(
                                create: (_) => widget.searchViewModel is OneWayTripViewModel
                                    ? widget.searchViewModel as OneWayTripViewModel
                                    : OneWayTripViewModel(),
                                child: const OneWayTripForm(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDepartureDate = 'Date Error';
    try {
      if (widget.searchViewModel.departureDate != null) {
        formattedDepartureDate = DateFormat('EEE, d MMM').format(widget.searchViewModel.departureDate!);
      }
    } catch (e) {
      debugPrint('Error formatting departureDate: ${widget.searchViewModel.departureDate}');
    }

    final departureCode = _extractCode(widget.searchViewModel.departureAirport);
    final arrivalCode = _extractCode(widget.searchViewModel.arrivalAirport);
    final passengerInfo =
        '${widget.searchViewModel.passengerAdults + widget.searchViewModel.passengerChilds + widget.searchViewModel.passengerInfants} pax, ${_getSeatClass()}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$departureCode → $arrivalCode',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  '$formattedDepartureDate, $passengerInfo',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showSearchOptionsDialog(context),
                  child: SvgPicture.asset(
                    'assets/icons/material-symbols-light_arrow-drop-down-rounded.svg',
                    width: 16,
                    height: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<FlightData>>(
        stream: Provider.of<FlightTicketViewModel>(context).flightStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                  ElevatedButton(
                    onPressed: () => Provider.of<FlightTicketViewModel>(context, listen: false).fetchFlights(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final flights = snapshot.data ?? [];
          if (flights.isEmpty) {
            return const Center(child: Text('No flights found.'));
          }

          final viewModel = Provider.of<FlightTicketViewModel>(context);
          final cheapestFlight = viewModel.findCheapestFlight();

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: (cheapestFlight != null ? 2 : 0) + flights.length + 1,
            itemBuilder: (context, index) {
              final offset = cheapestFlight != null ? 2 : 0;

              if (cheapestFlight != null && index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(left: 16, top: 8),
                  child: Text(
                    'Best Flight',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }
              if (cheapestFlight != null && index == 1) {
                return GestureDetector(
                  onTap: () {
                    viewModel.selectFlight(cheapestFlight);
                    viewModel.showTicketDetailsSheet(context);
                  },
                  child: FlightTicketCard(
                    viewModel: viewModel..selectFlight(cheapestFlight),
                    isBestCheap: true,
                  ),
                );
              }
              if (index == offset) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Text(
                    cheapestFlight != null ? 'All Flights' : 'Available Flights',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }

              final flight = flights[index - offset - 1];
              return GestureDetector(
                onTap: () {
                  viewModel.selectFlight(flight);
                  viewModel.showTicketDetailsSheet(context);
                },
                child: FlightTicketCard(viewModel: viewModel..selectFlight(flight)),
              );
            },
          );
        },
      ),
    );
  }
}