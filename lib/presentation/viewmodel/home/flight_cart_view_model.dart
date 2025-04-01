import 'package:flutter/material.dart';

class FlightCardViewModel extends ChangeNotifier {
  final Map<String, String> flight;

  FlightCardViewModel(this.flight);

  String get image => flight["image"] ?? 'assets/Logo/Primiter.png';
  String get route => flight["route"] ?? "";
  String get logo => flight["logo"] ?? "";
  String get date => flight["date"] ?? "Unknown Date";
  String get newPrice => flight["newPrice"] ?? "";
  String? get oldPrice => flight["oldPrice"];

  bool get hasOldPrice => oldPrice?.isNotEmpty ?? false;
  bool get hasRoute => route.isNotEmpty;
  bool get hasLogo => logo.isNotEmpty;
}
