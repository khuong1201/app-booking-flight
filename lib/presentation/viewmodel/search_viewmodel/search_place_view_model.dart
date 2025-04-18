import 'package:flutter/material.dart';
import 'package:booking_flight/data/airport_data.dart';

class SearchPlaceViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List<Map<String, String>> filteredAirports = [];

  // Function to update search_view query
  void onSearch(String value) {
    searchQuery = value;
    debugPrint('Search query: $searchQuery');
    filterAirports();
  }

  // Filter the airports based on the search_view query
  void filterAirports() {
    debugPrint('Filtering airports...');
    if (searchQuery.isEmpty) {
      // Nếu searchQuery rỗng, hiển thị tất cả sân bay
      filteredAirports = List.from(airports);
    } else {
      // Nếu searchQuery không rỗng, lọc theo truy vấn
      filteredAirports = airports.where((airport) {
        return airport["city"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            airport["name"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            airport["code"]!.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    debugPrint('Filtered Airports: $filteredAirports');
    notifyListeners();
  }

  // Get total airports after filtering (both domestic and international)
  int getTotalAirports() {
    return filteredAirports.length;
  }

  // Function to get domestic and international airports
  List<Map<String, String>> getDomesticAirports() {
    return filteredAirports.where((airport) => airport["type"] == "domestic").toList();
  }

  List<Map<String, String>> getInternationalAirports() {
    return filteredAirports.where((airport) => airport["type"] == "international").toList();
  }

  // Function to clear search_view and reset filter
  void clearSearch() {
    searchController.clear();
    onSearch(''); // Reset search_view with empty string
  }

  //Khởi tạo dữ liệu khi viewmodel được tạo ra.
  SearchPlaceViewModel(){
    if (searchQuery.isEmpty) {
      filteredAirports = List.from(airports);
    }
  }
}