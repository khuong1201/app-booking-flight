import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:booking_flight/data/passenger_infor_model.dart';

class ContactInfoStorage {
  // Dùng identifier là email hoặc phone để tạo key
  String _getContactId(String contactIdentifier) {
    final safeId = contactIdentifier.replaceAll(RegExp(r'[^\w]'), '_').toLowerCase();
    debugPrint('Using contactId: $safeId');
    return safeId;
  }

  Future<void> saveContactInfo(ContactInfo contactInfo, String contactIdentifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactId = _getContactId(contactIdentifier);
      final key = 'contact_info_$contactId';

      // Lưu cả email và phoneNumber
      final jsonString = jsonEncode({
        'email': contactInfo.email,
        'phoneNumber': contactInfo.phoneNumber,
      });

      await prefs.setString(key, jsonString);
      debugPrint('Saved ContactInfo (email & phone) for $contactId: $jsonString');
    } catch (e) {
      debugPrint('Error saving ContactInfo for $contactIdentifier: $e');
    }
  }

  Future<ContactInfo?> loadContactInfo(String contactIdentifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactId = _getContactId(contactIdentifier);
      final key = 'contact_info_$contactId';
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final jsonMap = jsonDecode(jsonString);
        debugPrint('Loaded ContactInfo (email & phone) for $contactId: $jsonMap');

        return ContactInfo(
          email: jsonMap['email'] ?? '',
          phoneNumber: jsonMap['phoneNumber'] ?? '',
        );
      }
      debugPrint('No saved ContactInfo found for $contactId');
      return null;
    } catch (e) {
      debugPrint('Error loading ContactInfo for $contactIdentifier: $e');
      return null;
    }
  }

  Future<void> clearContactInfo(String contactIdentifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactId = _getContactId(contactIdentifier);
      final key = 'contact_info_$contactId';
      await prefs.remove(key);
      debugPrint('Cleared saved ContactInfo for $contactId');
    } catch (e) {
      debugPrint('Error clearing ContactInfo for $contactIdentifier: $e');
    }
  }

  Future<void> debugStoredKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      debugPrint('Stored SharedPreferences keys: $keys');
      for (var key in keys) {
        debugPrint('Key: $key, Value: ${prefs.getString(key)}');
      }
    } catch (e) {
      debugPrint('Error debugging stored keys: $e');
    }
  }
}
