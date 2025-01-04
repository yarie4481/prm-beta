import 'dart:convert';
import 'package:beta_pm/models/property_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/super_user_model.dart';

class SuperUserController {
  static const String baseUrl =
      "https://pms-backend-sncw.onrender.com/api/v1/users";

  Future<SuperUser?> createSuperUser(
    String name,
    String email,
    String password,
    String role,
    String status,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('$baseUrl');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Send token in the header
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'status': status,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)['data'];
        return SuperUser.fromJson(data);
      } else {
        throw Exception('Failed to create superuser: ${response.body}');
      }
    } catch (e) {
      print('Error creating superuser: $e');
      return null;
    }
  }

  Future<List<SuperUser>> fetchSuperUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse(baseUrl);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Send token in the header
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final users = responseData['data']['users']; // Access nested 'users' list

      if (users is List) {
        return users.map((user) => SuperUser.fromJson(user)).toList();
      } else {
        throw Exception('Unexpected data format for users');
      }
    } else {
      throw Exception('Failed to fetch superusers: ${response.body}');
    }
  }

  Future<void> deleteSuperUser(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/$id');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Send token in the header
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete superuser: ${response.body}');
    }
  }

  Future<void> updateSuperUser(String id, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/$id');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Send token in the header
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update superuser: ${response.body}');
    }
  }

  Future<List<Property>> fetchProperties() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse(
      'https://pms-backend-sncw.onrender.com/api/v1/properties',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Send token in the header
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          jsonDecode(response.body)['data']['properties'];
      return jsonResponse.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch properties: ${response.body}');
    }
  }

  Future<void> deleteProperty(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse(
      'https://pms-backend-sncw.onrender.com/api/v1/properties/$id',
    );
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Send token in the header
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete property: ${response.body}');
    }
  }

  Future<void> updateProperty(String id, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse(
      'https://pms-backend-sncw.onrender.com/api/v1/properties/$id',
    );
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Send token in the header
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update property: ${response.body}');
    }
  }
}
