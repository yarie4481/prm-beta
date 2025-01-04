import 'package:beta_pm/models/MaintenanceRequest.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MaintenanceController extends GetxController {
  var maintenanceRequests = <MaintenanceRequest>[].obs;
  var isLoading = true.obs;

  final String baseUrl =
      'https://pms-backend-sncw.onrender.com/api/v1/maintenances';

  @override
  void onInit() {
    super.onInit();
    fetchMaintenanceRequests();
  }

  Future<void> fetchMaintenanceRequests() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final requests =
            (data['data']['maintenanceRequests'] as List)
                .map((json) => MaintenanceRequest.fromJson(json))
                .toList();
        maintenanceRequests.assignAll(requests);
      } else {
        Get.snackbar('Error', 'Failed to load maintenance requests');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch maintenance requests');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMaintenanceRequest(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        maintenanceRequests.removeWhere((request) => request.id == id);
        Get.snackbar('Success', 'Request deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete request');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete request');
    }
  }
}
