import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_flight/core/widget/app_bar_search_widget.dart';
import 'package:booking_flight/core/constants/constants.dart';
import 'package:booking_flight/presentation/viewmodel/searchmodel/search_place_view_model.dart';

class SearchPlace extends StatelessWidget {
  final String? selectedAirport;

  const SearchPlace({super.key, this.selectedAirport});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchPlaceViewModel(),
      child: Consumer<SearchPlaceViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                AppBarSearchWidget(
                  searchController: viewModel.searchController,
                  onCancel: () => Navigator.pop(context),
                  onSearch: (value) {
                    viewModel.onSearch(value);
                  },
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      debugPrint("Total Airports: ${viewModel.getTotalAirports()}"); // Thêm debugPrint ở đây
                      return viewModel.getTotalAirports() == 0
                          ? const Center(child: Text("No airports found."))
                          : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: viewModel.getTotalAirports(),
                        itemBuilder: (context, index) {
                          int domesticCount = viewModel.getDomesticAirports().length;

                          if (index == 0 && domesticCount > 0) {
                            return buildSectionTitle("Domestic");
                          } else if (index < domesticCount) {
                            return buildAirportItem(viewModel.getDomesticAirports()[index], context);
                          } else if (index == domesticCount && viewModel.getInternationalAirports().isNotEmpty) {
                            return buildSectionTitle("International");
                          } else {
                            int internationalIndex = index - domesticCount - 1;
                            return buildAirportItem(viewModel.getInternationalAirports()[internationalIndex], context);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      height: 37,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F2),
      ),
      child: Text(
        title,
        style: AppTextStyle.paragraph2,
      ),
    );
  }

  Widget buildAirportItem(Map<String, String> airport, BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            airport["city"] ?? "City not available",
            style: AppTextStyle.caption1.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            airport["name"] ?? "Name not available",
            style: AppTextStyle.caption1,
          ),
        ],
      ),
      leading: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF9C9C9C),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          airport["code"] ?? "Code",
          style: AppTextStyle.paragraph2.copyWith(color: const Color(0xFFD3D3D3)),
        ),
      ),
      onTap: () {
        Navigator.pop(context, airport);
      },
    );
  }
}