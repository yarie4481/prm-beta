class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, String> toJson() {
    return {'email': email, 'password': password};
  }
}

class LoginResponse {
  final String token;
  final String message;

  LoginResponse({required this.token, required this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      message: json['message'] ?? 'No message available',
    );
  }
}
