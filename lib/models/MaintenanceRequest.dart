class MaintenanceRequest {
  final String id;
  final String tenantName;
  final String typeOfRequest;
  final String description;
  final String urgencyLevel;
  final String propertyTitle;
  final String preferredAccessTimes;

  MaintenanceRequest({
    required this.id,
    required this.tenantName,
    required this.typeOfRequest,
    required this.description,
    required this.urgencyLevel,
    required this.propertyTitle,
    required this.preferredAccessTimes,
  });

  factory MaintenanceRequest.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequest(
      id: json['_id'] ?? '',
      tenantName: json['tenant']?['tenantName'] ?? '',
      typeOfRequest: json['typeOfRequest'] ?? '',
      description: json['description'] ?? '',
      urgencyLevel: json['urgencyLevel'] ?? '',
      propertyTitle: json['property']?['title'] ?? '',
      preferredAccessTimes: json['preferredAccessTimes'] ?? '',
    );
  }
}
