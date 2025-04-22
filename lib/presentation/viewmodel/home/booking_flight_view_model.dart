import 'dart:convert';

import 'package:booking_flight/data/contact_info_storage.dart';
import 'package:booking_flight/data/passenger_infor_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingFlightViewModel extends ChangeNotifier {
  int _tabIndex = 0;
  int _bottomNavIndex = 0;
  bool _hasError = false;
  String _errorMessage = '';
  String? _contactId;
  final ContactInfoStorage _storage = ContactInfoStorage();

  int get tabIndex => _tabIndex;
  int get bottomNavIndex => _bottomNavIndex;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  String? get contactId => _contactId;

  BookingFlightViewModel() {
    _loadContactId();
  }

  Future<void> _loadContactId() async {
    try {
      // Load all stored contact info keys to find a valid contact
      await _storage.debugStoredKeys(); // Log all stored keys for debugging
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('contact_info_')).toList();

      if (keys.isNotEmpty) {
        for (var key in keys) {
          final jsonString = prefs.getString(key);
          if (jsonString != null) {
            final jsonMap = jsonDecode(jsonString);
            final contactInfo = ContactInfo.fromJson(jsonMap);
            // Set contactId to the first valid identifier (email or phone)
            if (contactInfo.email != null && contactInfo.email!.isNotEmpty) {
              _contactId = contactInfo.email;
              debugPrint('Set contactId to email: $_contactId');
              notifyListeners();
              return;
            } else if (contactInfo.phoneNumber != null && contactInfo.phoneNumber!.isNotEmpty) {
              _contactId = contactInfo.phoneNumber;
              debugPrint('Set contactId to phoneNumber: $_contactId');
              notifyListeners();
              return;
            }
          }
        }
      }

      // Fallback: Try loading with default_user
      final contactInfo = await _storage.loadContactInfo('default_user');
      if (contactInfo != null) {
        if (contactInfo.email != null && contactInfo.email!.isNotEmpty) {
          _contactId = contactInfo.email;
          debugPrint('Set contactId to default_user email: $_contactId');
        } else if (contactInfo.phoneNumber != null && contactInfo.phoneNumber!.isNotEmpty) {
          _contactId = contactInfo.phoneNumber;
          debugPrint('Set contactId to default_user phoneNumber: $_contactId');
        } else {
          _contactId = 'default_user';
          debugPrint('No valid contact info found, using default_user');
        }
      } else {
        _contactId = 'default_user';
        debugPrint('No contact info found for default_user, using default_user');
      }
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error loading contact info: $e';
      debugPrint('Error in _loadContactId: $e');
      notifyListeners();
    }
  }

  // Manually set the contactId with the given identifier
  void setContactId(String identifier) {
    _contactId = identifier;
    debugPrint('Manually set contactId to: $identifier');
    notifyListeners();
  }

  void onTabTapped(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void onBottomNavTapped(int index) {
    _bottomNavIndex = index;
    notifyListeners();
  }

  void setError(String message) {
    _hasError = true;
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }
}
