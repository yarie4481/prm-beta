class SuperUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String? phoneNumber;

  SuperUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.phoneNumber,
  });

  factory SuperUser.fromJson(Map<String, dynamic> json) {
    return SuperUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      phoneNumber: json['phoneNumber'], // Optional
    );
  }
}
