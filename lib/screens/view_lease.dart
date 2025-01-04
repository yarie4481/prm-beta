import 'package:beta_pm/screens/add_lease.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Lease {
  final String id;
  final String tenantName;
  final String propertyTitle;
  final String leaseStart;
  final String leaseEnd;
  final int rentAmount;
  final int securityDeposit;
  final String paymentMethod;
  final String rulesAndConditions;
  final List<String> additionalOccupants;
  final String utilitiesAndServices;

  Lease({
    required this.id,
    required this.tenantName,
    required this.propertyTitle,
    required this.leaseStart,
    required this.leaseEnd,
    required this.rentAmount,
    required this.securityDeposit,
    required this.paymentMethod,
    required this.rulesAndConditions,
    required this.additionalOccupants,
    required this.utilitiesAndServices,
  });

  factory Lease.fromJson(Map<String, dynamic> json) {
    final tenant = json['tenant'] ?? {};
    final property = json['property'] ?? {};
    return Lease(
      id: json['_id'] ?? '',
      tenantName: tenant['tenantName'] ?? 'Unknown Tenant',
      propertyTitle: property['title'] ?? 'Unknown Property',
      leaseStart: json['leaseStart'] ?? 'N/A',
      leaseEnd: json['leaseEnd'] ?? 'N/A',
      rentAmount: json['rentAmount'] ?? 0,
      securityDeposit: json['securityDeposit'] ?? 0,
      paymentMethod: tenant['paymentMethod'] ?? 'Unknown',
      rulesAndConditions: json['rulesAndConditions'] ?? 'No rules provided',
      additionalOccupants:
          (json['additionalOccupants'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      utilitiesAndServices: json['utilitiesAndServices'] ?? 'Not specified',
    );
  }
}

class LeaseListScreen extends StatefulWidget {
  @override
  _LeaseListScreenState createState() => _LeaseListScreenState();
}

class _LeaseListScreenState extends State<LeaseListScreen> {
  final String apiUrl = "https://pms-backend-sncw.onrender.com/api/v1/lease";
  late Future<List<Lease>> leases;

  Future<List<Lease>> fetchLeases() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> leasesData = jsonResponse['data']['leases'];
      return leasesData.map((json) => Lease.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load leases');
    }
  }

  void _showUpdateDialog(Lease lease) {
    final TextEditingController tenantNameController = TextEditingController(
      text: lease.tenantName,
    );
    final TextEditingController propertyTitleController = TextEditingController(
      text: lease.propertyTitle,
    );
    final TextEditingController leaseStartController = TextEditingController(
      text: lease.leaseStart,
    );
    final TextEditingController leaseEndController = TextEditingController(
      text: lease.leaseEnd,
    );
    final TextEditingController rentController = TextEditingController(
      text: lease.rentAmount.toString(),
    );
    final TextEditingController securityDepositController =
        TextEditingController(text: lease.securityDeposit.toString());
    final TextEditingController paymentMethodController = TextEditingController(
      text: lease.paymentMethod,
    );
    final TextEditingController rulesAndConditionsController =
        TextEditingController(text: lease.rulesAndConditions);
    final TextEditingController utilitiesController = TextEditingController(
      text: lease.utilitiesAndServices,
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Update Lease',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: tenantNameController,
                    decoration: InputDecoration(labelText: 'Tenant Name'),
                  ),
                  TextField(
                    controller: propertyTitleController,
                    decoration: InputDecoration(labelText: 'Property Title'),
                  ),
                  TextField(
                    controller: leaseStartController,
                    decoration: InputDecoration(labelText: 'Lease Start Date'),
                  ),
                  TextField(
                    controller: leaseEndController,
                    decoration: InputDecoration(labelText: 'Lease End Date'),
                  ),
                  TextField(
                    controller: rentController,
                    decoration: InputDecoration(labelText: 'Rent Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: securityDepositController,
                    decoration: InputDecoration(labelText: 'Security Deposit'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: paymentMethodController,
                    decoration: InputDecoration(labelText: 'Payment Method'),
                  ),
                  TextField(
                    controller: rulesAndConditionsController,
                    decoration: InputDecoration(
                      labelText: 'Rules and Conditions',
                    ),
                  ),
                  TextField(
                    controller: utilitiesController,
                    decoration: InputDecoration(
                      labelText: 'Utilities and Services',
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final updatedData = {
                            'tenantName': tenantNameController.text,
                            'propertyTitle': propertyTitleController.text,
                            'leaseStart': leaseStartController.text,
                            'leaseEnd': leaseEndController.text,
                            'rentAmount':
                                int.tryParse(rentController.text) ??
                                lease.rentAmount,
                            'securityDeposit':
                                int.tryParse(securityDepositController.text) ??
                                lease.securityDeposit,
                            'paymentMethod': paymentMethodController.text,
                            'rulesAndConditions':
                                rulesAndConditionsController.text,
                            'utilitiesAndServices': utilitiesController.text,
                          };
                          updateLease(lease.id, updatedData);
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Update'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> updateLease(String id, Map<String, dynamic> updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      setState(() {
        leases = fetchLeases();
      });
    } else {
      throw Exception('Failed to update lease');
    }
  }

  Future<void> deleteLease(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        leases = fetchLeases();
      });
    } else {
      throw Exception('Failed to delete lease');
    }
  }

  @override
  void initState() {
    super.initState();
    leases = fetchLeases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(251, 232, 229, 229),

      appBar: AppBar(title: Text('Agreements'), centerTitle: true),
      body: FutureBuilder<List<Lease>>(
        future: leases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No leases found'));
          } else {
            final leaseList = snapshot.data!;
            return ListView.builder(
              itemCount: leaseList.length,
              itemBuilder: (context, index) {
                final lease = leaseList[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              lease.tenantName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                // Trigger update logic
                                _showUpdateDialog(lease);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _confirmDelete(lease.id);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.home, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Property: ${lease.propertyTitle}'),
                          ],
                        ),
                        Divider(),
                        Text(
                          'Lease Period: ${lease.leaseStart} - ${lease.leaseEnd}',
                        ),
                        Text('Rent: \$${lease.rentAmount}'),
                        Text('Security Deposit: \$${lease.securityDeposit}'),
                        Divider(),
                        Text('Payment Method: ${lease.paymentMethod}'),
                        Text('Rules: ${lease.rulesAndConditions}'),
                        Divider(),
                        Text('Utilities: ${lease.utilitiesAndServices}'),
                        Text('Additional Occupants:'),
                        ...lease.additionalOccupants.map(
                          (occupant) => Text('- $occupant'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LeaseRegistrationScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Delete Lease'),
            content: Text('Are you sure you want to delete this lease?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  deleteLease(id);
                  Navigator.of(ctx).pop();
                },
                child: Text('Delete'),
              ),
            ],
          ),
    );
  }
}
