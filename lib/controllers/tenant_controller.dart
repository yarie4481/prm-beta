import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TenantService {
  final String baseUrl = 'https://pms-backend-sncw.onrender.com/api/v1/tenants';

  Future<http.Response> createTenant(Map<String, dynamic> tenantData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse(baseUrl);
    final headers = {'Authorization': 'Bearer $token'};
    final request =
        http.MultipartRequest('POST', uri)
          ..headers.addAll(headers)
          ..fields.addAll(
            tenantData.map((key, value) => MapEntry(key, value.toString())),
          );
    return http.Response.fromStream(await request.send());
  }

  Future<http.Response> updateTenant(
    String tenantId,
    Map<String, dynamic> tenantData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse('$baseUrl/$tenantId');
    final headers = {'Authorization': 'Bearer $token'};

    // Convert tenantData to JSON (use json.encode to serialize the nested maps)
    final body = json.encode(tenantData);

    final response = await http.put(uri, headers: headers, body: body);

    return response;
  }

  Future<List<dynamic>> fetchTenants() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse(baseUrl);
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      // Return the list of tenants
      return decodedResponse['data']['tenants'];
    } else {
      throw Exception('Failed to fetch tenants');
    }
  }

  Future<http.Response> deleteTenant(String tenantId) async {
    final uri = Uri.parse('$baseUrl/$tenantId');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.delete(uri, headers: headers);
    return response;
  }
}
