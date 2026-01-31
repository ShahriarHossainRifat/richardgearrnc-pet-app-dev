import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/product_model.dart'; // your model file

class ProductController extends GetxController {
  // ── State ────────────────────────────────────────────────────────
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var products = <Product>[].obs; // ← list from your model

  // Hardcoded token for quick testing (NEVER commit this!)
  // In real app → load from secure storage / auth service
  final String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjFlNGQ4MzMyLTE5NDQtNDkyYS1hYWE3LTNkNTc5OTczMGJlNiIsImVtYWlsIjoiYmFpYnVyMTIxNkBnbWFpbC5jb20iLCJyb2xlIjoiUEVUX09XTkVSIiwiaWF0IjoxNzY5ODY1MTUxLCJleHAiOjE3Njk5NTE1NTF9.TDn_6qsZIQo0kqCH6VOEFH4f2gg7b1XRWjKJSMrz0Lw';

  // Dio instance
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://clever-iguana-terminally.ngrok-free.app',
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
        headers: {'Accept': 'application/json'},
      ),
    );

    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _dio.get(
        '/api/product',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Safe type check + cast
        final jsonData = response.data;
        if (jsonData is! Map<String, dynamic>) {
          throw Exception('Invalid response format');
        }

        final model = ProductResponse.fromJson(jsonData);

        if (model.success == true) {
          products.assignAll(model.data.data);
          print('Loaded ${products.length} products');
        } else {
          hasError.value = true;
          errorMessage.value = model.message;
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } on DioException catch (e) {
      hasError.value = true;
      if (e.response != null) {
        errorMessage.value =
        'Error ${e.response?.statusCode}: ${e.response?.data?['message'] ?? 'No detail'}';
      } else {
        errorMessage.value = 'Network issue: ${e.message}';
      }
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Unexpected: $e';
      Get.snackbar('Crash', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Pull-to-refresh
  Future<void> refresh() => fetchProducts();
}