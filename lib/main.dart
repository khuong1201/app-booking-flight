import 'package:booking_flight/presentation/view/welcome_view/welcome_view.dart';
import 'package:booking_flight/presentation/viewmodel/home/booking_flight_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/home/one_way_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/home/round_trip_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Khởi tạo Firebase
  await initializeDateFormatting('vi_VN', null); // Khởi tạo dữ liệu ngôn ngữ cho tiếng Việt
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingFlightViewModel()),
        ChangeNotifierProvider(create: (_) => OneWayTripViewModel()),
        ChangeNotifierProvider(create: (_) => RoundTripFormViewModel()),
      ],
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingFlightViewModel(),
      child: MaterialApp(
        title: 'Primiter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}