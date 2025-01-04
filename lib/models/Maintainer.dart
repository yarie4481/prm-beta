class Maintainer {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final List<String> maintenanceSkills;
  final Map<String, bool> permissions;

  Maintainer({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.maintenanceSkills,
    required this.permissions,
  });

  factory Maintainer.fromJson(Map<String, dynamic> json) {
    return Maintainer(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      maintenanceSkills: List<String>.from(json['maintenanceSkills']),
      permissions: Map<String, bool>.from(json['permissions']),
    );
  }
}
