import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static Future<bool> isConnected() async {
    var connectivityResults = await Connectivity().checkConnectivity(); // Lấy danh sách kết quả
    return connectivityResults.isNotEmpty && connectivityResults.first != ConnectivityResult.none;
  }
}