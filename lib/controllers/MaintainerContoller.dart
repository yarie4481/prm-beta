import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/maintainer.dart';

class MaintainerController extends GetxController {
  var maintainers = <Maintainer>[].obs;
  var isLoading = false.obs;

  final String apiUrl =
      'https://pms-backend-sncw.onrender.com/api/v1/maintenances/maintainers'; // Replace with actual API URL

  @override
  void onInit() {
    fetchMaintainers();
    super.onInit();
  }

  Future<void> fetchMaintainers() async {
    try {
      isLoading(true);

      // Get token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(
        'token',
      ); // Assuming the token is stored with the key 'token'

      // Set headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Make the API call with the headers
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          final data = jsonData['data'] as List;
          maintainers.value = data.map((e) => Maintainer.fromJson(e)).toList();
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch maintainers');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<http.Response> assignMaintainers(
    Map<String, dynamic> payload,
    String maintenanceId,
  ) async {
    try {
      // Get token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Set headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Make the API call
      final String api =
          "https://pms-backend-sncw.onrender.com/api/v1/maintenances/assign/$maintenanceId";
      print(api);
      final response = await http.put(
        Uri.parse(api),
        headers: headers,
        body: jsonEncode(payload),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Maintainer assigned successfully');
      } else {
        Get.snackbar('Error', 'Failed to assign maintainer');
      }

      return response;
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      rethrow;
    }
  }
}
