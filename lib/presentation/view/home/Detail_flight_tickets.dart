import 'package:flutter/material.dart';
import '../../viewmodel/home/Detail_flight_tickets_view_model.dart';
import 'package:booking_flight/core/constants/constants.dart';

import '../search/passenger_information_view.dart';

class TicketDetailsView extends StatelessWidget {
  final DetailFlightTicketsViewModel viewModel;
  final VoidCallback? onClose;

  const TicketDetailsView({super.key, required this.viewModel, this.onClose});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final desiredHeight = screenHeight * 0.8;
    return SizedBox(
      height: desiredHeight,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            'Ticket Details',
            style: AppTextStyle.heading4.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xFFE3E8F7),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewModel.routeTitle,
                        style: AppTextStyle.heading3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(viewModel.airlineLogo,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.airplane_ticket_outlined,
                                    size: 40,
                                    color: Colors.grey,
                                  )),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(viewModel.airlineName,
                                      style: AppTextStyle.body3
                                          .copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text(viewModel.flightCode,
                                      style: AppTextStyle.paragraph1
                                          .copyWith(color: const Color(0xFF757575))),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Color(0xFFEEEEEE), thickness: 1),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFlightDetailColumn(
                                  viewModel.departureTime,
                                  viewModel.departureAirport,
                                  viewModel.departureDate,
                                  CrossAxisAlignment.start),
                              _buildDurationColumn(
                                  viewModel.flightDuration, viewModel.flightType),
                              _buildFlightDetailColumn(
                                  viewModel.arrivalTime,
                                  viewModel.arrivalAirport,
                                  viewModel.arrivalDate,
                                  CrossAxisAlignment.end),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Baggage Information"),
                      _buildInfoRow(
                        "Checked Baggage:",
                        viewModel.checkedBaggage,
                        Image.asset('assets/icons/carry-on-bag.png',
                            width: 24, height: 24),
                      ),
                      _buildInfoRow(
                        "Carry-on Baggage:",
                        viewModel.carryOnBaggage,
                        Image.asset('assets/icons/Trip.png', width: 24, height: 24),
                      ),
                      const SizedBox(height: 16),
                      _buildSectionTitle("Policies & Conditions"),
                      buildExpandableSection(
                        title: "Flight/Date/Itinerary Changes",
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: viewModel.flightChanges
                              .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(e,
                                style: AppTextStyle.caption1
                                    .copyWith(color: Colors.black87)),
                          ))
                              .toList(),
                        ),
                      ),
                      buildExpandableSection(
                        title: "Passenger Name Change",
                        content: Text(viewModel.passengerNameChange,
                            style: AppTextStyle.caption1
                                .copyWith(color: Colors.black87)),
                      ),
                      buildExpandableSection(
                        title: "Ticket Upgrade",
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: viewModel.ticketUpgrade
                              .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(e,
                                style: AppTextStyle.caption1
                                    .copyWith(color: Colors.black87)),
                          ))
                              .toList(),
                        ),
                      ),
                      buildExpandableSection(
                        title: "No-show & Cancellation",
                        content: Text(viewModel.noShowPolicy,
                            style: AppTextStyle.caption1
                                .copyWith(color: Colors.black87)),
                      ),
                      buildExpandableSection(
                        title: "Refund & Credit Policy",
                        content: Text(viewModel.refundPolicy,
                            style: AppTextStyle.caption1
                                .copyWith(color: Colors.black87)),
                      ),
                      buildExpandableSection(
                        title: "Fare Details",
                        content: Card(
                          elevation: 0,
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFareRow(
                                  label:
                                  "${viewModel.searchTicketData.passengerAdults} x Adult",
                                  fare: viewModel.adultFareString,
                                ),
                                _buildFareRow(
                                  label:
                                  "${viewModel.searchTicketData.passengerChilds} x Child",
                                  fare: viewModel.childFareString,
                                ),
                                _buildFareRow(
                                  label:
                                  "${viewModel.searchTicketData.passengerInfants} x Infant",
                                  fare: viewModel.infantFareString,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, right: 24, left: 24, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Amount",
                            style: AppTextStyle.paragraph2
                                .copyWith(color: Colors.grey[600])),
                        const Spacer(),
                        Text(viewModel.totalAmountString,
                            style: AppTextStyle.body3.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PassengerInfoScreen(
                              adultCount: viewModel.passengerAdults,
                              childCount: viewModel.passengerChilds,
                              infantCount: viewModel.passengerInfants,
                              ticketPrice: viewModel.totalAmountString,
                              routerTrip: viewModel.routeTitle,
                              logoAirPort: viewModel.airlineLogo,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(343, 48),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Select Flight",
                          style: AppTextStyle.heading4
                              .copyWith(color: const Color(0xFFF2F2F2))),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExpandableSection(
      {required String title, required Widget content, IconData? icon}) {
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 0),
      leading: icon != null ? Icon(icon, color: AppColors.primaryColor) : null,
      title: Text(title,
          style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.w500)),
      childrenPadding:
      const EdgeInsets.only(left: 0, right: 0, bottom: 12, top: 0),
      expandedAlignment: Alignment.centerLeft,
      children: [content],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(title,
          style: AppTextStyle.body3
              .copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildInfoRow(String label, String value, Widget icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 8),
          Text("$label ", style: AppTextStyle.paragraph1.copyWith(fontSize: 12)),
          Expanded(
              child: Text(value,
                  style: AppTextStyle.paragraph1.copyWith(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildFlightDetailColumn(String time, String airport, String date,
      CrossAxisAlignment alignment) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        Text(time,
            style: AppTextStyle.heading3.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(airport,
            style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(date,
            style: AppTextStyle.caption1.copyWith(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildDurationColumn(String duration, String type) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(duration,
            style: AppTextStyle.caption1.copyWith(color: const Color(0xFF9C9C9C))),
        const SizedBox(height: 4),
        SizedBox(
            width: 60,
            child: Stack(alignment: Alignment.centerRight, children: const [
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Divider(
                          color: Color(0xFF9C9C9C), thickness: 1, indent: 0, endIndent: 4))),
              Icon(Icons.arrow_forward, size: 12, color: Color(0xFF9C9C9C))
            ])),
        const SizedBox(height: 4),
        Text(type,
            style: AppTextStyle.caption1
                .copyWith(fontSize: 10, color: const Color(0xFF9C9C9C))),
      ],
    );
  }

  Widget _buildFareRow({required String label, required String fare, bool isMuted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.paragraph1
                .copyWith(color: isMuted ? Colors.grey[700] : null),
          ),
          Text(
            fare,
            style: AppTextStyle.paragraph1.copyWith(
                fontWeight: isMuted ? FontWeight.normal : FontWeight.w500,
                color: isMuted ? Colors.grey[700] : null),
          ),
        ],
      ),
    );
  }
}