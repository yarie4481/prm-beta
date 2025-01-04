import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';

class LoginController {
  final String _loginUrl =
      'https://pms-backend-sncw.onrender.com/api/v1/auth/login';

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        body: request.toJson(),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      print(request.toJson());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(response.body);
        print(data);

        return LoginResponse.fromJson(data['data']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
