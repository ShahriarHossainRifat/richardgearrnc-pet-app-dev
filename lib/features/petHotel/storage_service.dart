// lib/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<String> getToken() async {
    // Example with SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('🔐 Retrieved token: $token'); // 👈 ADD THIS FOR DEBUGGING
    return token ?? '';
  }
}