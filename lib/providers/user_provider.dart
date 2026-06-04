import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String _username = '';
  String _photoUrl = '';
  bool _pushNotifications = true;
  bool _promoNotifications = false;

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get address => _address;
  String get username => _username;
  String get photoUrl => _photoUrl;
  bool get pushNotifications => _pushNotifications;
  bool get promoNotifications => _promoNotifications;

  // Ambil data dari Firestore berdasarkan uid user yang login
  Future<void> loadUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _name = data['name'] ?? '';
        _email = data['email'] ?? '';
        _phone = data['phone'] ?? '';
        _address = data['address'] ?? '';
        _username = data['username'] ?? '';
        _photoUrl = data['photoUrl'] ?? '';
      }

      // Tetap load preferensi notifikasi dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      _pushNotifications = prefs.getBool('pushNotifications') ?? true;
      _promoNotifications = prefs.getBool('promoNotifications') ?? false;

      notifyListeners();
    } catch (e) {
      debugPrint('Error loadUser: $e');
    }
  }

  // Update profil ke Firestore
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      });

      _name = name;
      _email = email;
      _phone = phone;
      _address = address;

      notifyListeners();
    } catch (e) {
      debugPrint('Error updateProfile: $e');
    }
  }

  Future<void> togglePushNotifications(bool value) async {
    _pushNotifications = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', value);
    notifyListeners();
  }

  Future<void> togglePromoNotifications(bool value) async {
    _promoNotifications = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('promoNotifications', value);
    notifyListeners();
  }
}