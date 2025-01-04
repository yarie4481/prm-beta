class Tenant {
  String tenantName;
  ContactInformation contactInformation;
  LeaseAgreement leaseAgreement;
  PropertyInformation propertyInformation;
  String password;
  String paymentMethod;
  String moveInDate;
  List<String> emergencyContacts;
  List<String> idProof;

  Tenant({
    required this.tenantName,
    required this.contactInformation,
    required this.leaseAgreement,
    required this.propertyInformation,
    required this.password,
    required this.paymentMethod,
    required this.moveInDate,
    required this.emergencyContacts,
    required this.idProof,
  });

  Map<String, dynamic> toJson() => {
    'tenantName': tenantName,
    'contactInformation': contactInformation.toJson(),
    'leaseAgreement': leaseAgreement.toJson(),
    'propertyInformation': propertyInformation.toJson(),
    'password': password,
    'paymentMethod': paymentMethod,
    'moveInDate': moveInDate,
    'emergencyContacts': emergencyContacts,
    'idProof': idProof,
  };
}

class ContactInformation {
  String email;
  String phoneNumber;
  String emergencyContact;

  ContactInformation({
    required this.email,
    required this.phoneNumber,
    required this.emergencyContact,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'phoneNumber': phoneNumber,
    'emergencyContact': emergencyContact,
  };
}

class LeaseAgreement {
  String startDate;
  String endDate;
  double rentAmount;
  double securityDeposit;
  String specialTerms;

  LeaseAgreement({
    required this.startDate,
    required this.endDate,
    required this.rentAmount,
    required this.securityDeposit,
    required this.specialTerms,
  });

  Map<String, dynamic> toJson() => {
    'startDate': startDate,
    'endDate': endDate,
    'rentAmount': rentAmount,
    'securityDeposit': securityDeposit,
    'specialTerms': specialTerms,
  };
}

class PropertyInformation {
  String unit;
  String propertyId;

  PropertyInformation({required this.unit, required this.propertyId});

  Map<String, dynamic> toJson() => {'unit': unit, 'propertyId': propertyId};
}
