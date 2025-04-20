import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/constants.dart';
import '../../../core/widget/tab_bar_widget.dart';
import '../../../data/search_flight_data.dart';
import '../../../data/SearchViewModel.dart';
import '../../viewmodel/search_viewmodel/search_flight_tiket_view_model.dart';
import '../home/one_way_trip_form_view.dart';
import '../home/round_trip_form_view.dart';

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
      width: 379,
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isBestCheap ? AppColors.secondaryColor : const Color(0xFF9C9C9C),
          width: 1.5,
        ),
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
                const Icon(Icons.airplane_ticket, size: 30),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildFlightTimeColumn(
                            viewModel.departureTime, viewModel.departureAirport, CrossAxisAlignment.start),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              viewModel.duration,
                              style: const TextStyle(color: Color(0xFF9C9C9C), fontSize: 12),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 1,
                                  width: 60,
                                  color: const Color(0xFF9C9C9C),
                                ),
                                const SizedBox(width: 2),
                                Transform.scale(
                                  scaleX: 2.0,
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 8,
                                    color: Color(0xFF9C9C9C),
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'Direct',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9C9C9C),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        buildFlightTimeColumn(
                            viewModel.arrivalTime, viewModel.arrivalAirport, CrossAxisAlignment.end),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 40,
                width: 1,
                color: const Color(0xFF9C9C9C),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    viewModel.price,
                    style: AppTextStyle.body3.copyWith(color: AppColors.secondaryColor),
                  ),
                  Text(
                    viewModel.passengerCount,
                    style: const TextStyle(color: Color(0xFF9C9C9C), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                viewModel.airlineName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Details",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      viewModel.showTicketDetailsSheet(context);
                    },
                    child: const Icon(Icons.error_outline, color: Colors.red, size: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFlightTimeColumn(String time, String airport, CrossAxisAlignment alignment) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          airport,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
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
  late List<FlightTicketViewModel> allViewModelList;
  late List<FlightTicketViewModel> filteredList;
  FlightTicketViewModel? cheapestFlight;
  bool isLoading = true;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAndFilterFlights();
  }

  String _extractCode(Map<String, dynamic>? airport) {
    return airport?['code'] ?? '';
  }

  String _getSeatClass() {
    // Kiểm tra kiểu của searchViewModel để lấy seatClass
    if (widget.searchViewModel is OneWayTripViewModel) {
      return (widget.searchViewModel as OneWayTripViewModel).seatClass;
    } else if (widget.searchViewModel is RoundTripFormViewModel) {
      return (widget.searchViewModel as RoundTripFormViewModel).seatClass;
    }
    return 'Unknown';
  }

  void _initializeAndFilterFlights() {
    setState(() => isLoading = true);

    allViewModelList = FlightTicketViewModel.fetchAllData(flightDataList, widget.searchViewModel);

    print(
        'Filtering flights for: ${_extractCode(widget.searchViewModel.departureAirport)} -> ${_extractCode(widget.searchViewModel.arrivalAirport)} on ${widget.searchViewModel.departureDate}');
    filteredList = FlightTicketViewModel.filterFlights(
      flights: allViewModelList,
      departureInfo: "${widget.searchViewModel.departureAirport?['city'] ?? ''} (${widget.searchViewModel.departureAirport?['code'] ?? ''})",
      arrivalInfo: "${widget.searchViewModel.arrivalAirport?['city'] ?? ''} (${widget.searchViewModel.arrivalAirport?['code'] ?? ''})",
      date: widget.searchViewModel.departureDate != null
          ? DateFormat('yyyy-MM-dd').format(widget.searchViewModel.departureDate!)
          : DateTime.now().toIso8601String().split('T')[0],
      isRoundTrip: widget.searchViewModel.returnDate != null,
      returnDate: widget.searchViewModel.returnDate != null
          ? DateFormat('yyyy-MM-dd').format(widget.searchViewModel.returnDate!)
          : null,
    );
    print('Found ${filteredList.length} matching flights.');

    cheapestFlight = FlightTicketViewModel.findCheapestFlight(filteredList);

    setState(() => isLoading = false);
  }

  void _showSearchOptionsDialog(BuildContext context) {
    int localTabIndex = _tabIndex;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.only(top: 0, left: 0, right: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                color: AppColors.primaryColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Search new flight',
                          style: AppTextStyle.paragraph1.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
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
                              children: [
                                // Sử dụng instance hiện tại nếu có
                                widget.searchViewModel is RoundTripFormViewModel
                                    ? Provider<RoundTripFormViewModel>.value(
                                  value: widget.searchViewModel as RoundTripFormViewModel,
                                  child: const RoundTripForm(),
                                )
                                    : Provider<RoundTripFormViewModel>(
                                  create: (_) => RoundTripFormViewModel(),
                                  child: const RoundTripForm(),
                                ),
                                widget.searchViewModel is OneWayTripViewModel
                                    ? Provider<OneWayTripViewModel>.value(
                                  value: widget.searchViewModel as OneWayTripViewModel,
                                  child: const OneWayTripForm(),
                                )
                                    : Provider<OneWayTripViewModel>(
                                  create: (_) => OneWayTripViewModel(),
                                  child: const OneWayTripForm(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
      if (widget.searchViewModel.departureDate != null) {
        formattedDepartureDate =
            DateFormat('EEE, d MMM').format(widget.searchViewModel.departureDate!);
      }
    } catch (e) {
      print("Error formatting departureDate: ${widget.searchViewModel.departureDate}");
    }

    String departureCode = _extractCode(widget.searchViewModel.departureAirport);
    String arrivalCode = _extractCode(widget.searchViewModel.arrivalAirport);
    String passengerInfo =
        "${widget.searchViewModel.passengerAdults + widget.searchViewModel.passengerChilds + widget.searchViewModel.passengerInfants} pax, ${_getSeatClass()}";

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
                    "$departureCode  →  $arrivalCode",
                    style: AppTextStyle.paragraph2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: Text(
                    "$formattedDepartureDate, $passengerInfo",
                    style: AppTextStyle.caption1.copyWith(color: const Color(0xFFE0E0E0)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _showSearchOptionsDialog(context),
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
          ? const Center(child: CircularProgressIndicator())
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

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: (cheapestFlight != null ? 2 : 0) + filteredList.length + 2,
      itemBuilder: (context, index) {
        int offset = cheapestFlight != null ? 2 : 0;

        if (cheapestFlight != null && index == 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 4.0),
            child: Text(
              'Best flight from your search',
              style: AppTextStyle.paragraph1.copyWith(fontWeight: FontWeight.bold),
            ),
          );
        }

        if (cheapestFlight != null && index == 1) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  cheapestFlight!.showTicketDetailsSheet(context);
                },
                child: FlightTicketCard(viewModel: cheapestFlight!, isBestCheap: true),
              ),
              const Divider(indent: 16, endIndent: 16, height: 20),
            ],
          );
        }

        if (index == offset) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 4.0),
            child: Text(
              cheapestFlight != null ? 'All flights' : 'Available flights',
              style: AppTextStyle.paragraph1.copyWith(fontWeight: FontWeight.bold),
            ),
          );
        }

        if (index == offset + filteredList.length + 1) {
          return const SizedBox(height: 20);
        }

        final flight = filteredList[index - offset - 1];
        return GestureDetector(
          onTap: () {
            flight.showTicketDetailsSheet(context);
          },
          child: FlightTicketCard(viewModel: flight, isBestCheap: false),
        );
      },
    );
  }
}