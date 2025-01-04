import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LeaseRegistrationScreen extends StatefulWidget {
  @override
  _LeaseRegistrationScreenState createState() =>
      _LeaseRegistrationScreenState();
}

class _LeaseRegistrationScreenState extends State<LeaseRegistrationScreen> {
  final String apiUrl = "https://pms-backend-sncw.onrender.com/api/v1/lease";

  // Controllers for user input
  final TextEditingController tenantController = TextEditingController();
  final TextEditingController propertyController = TextEditingController();
  final TextEditingController leaseStartController = TextEditingController();
  final TextEditingController leaseEndController = TextEditingController();
  final TextEditingController rentAmountController = TextEditingController();
  final TextEditingController securityDepositController =
      TextEditingController();
  final TextEditingController paymentDueDateController =
      TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  final TextEditingController utilitiesController = TextEditingController();
  final TextEditingController additionalOccupantsController =
      TextEditingController();

  bool isLoading = false;

  Future<void> registerLease() async {
    setState(() {
      isLoading = true;
    });

    // Build the payload
    final Map<String, dynamic> leaseData = {
      "tenant": "6746ccede2bc398642a12540",
      "property": "6746ca22e2bc398642a1253a",
      "leaseStart": leaseStartController.text,
      "leaseEnd": leaseEndController.text,
      "rentAmount": int.tryParse(rentAmountController.text) ?? 0,
      "securityDeposit": int.tryParse(securityDepositController.text) ?? 0,
      "paymentTerms": {
        "dueDate": paymentDueDateController.text,
        "paymentMethod": paymentMethodController.text,
      },
      "rulesAndConditions": rulesController.text,
      "additionalOccupants":
          additionalOccupantsController.text
              .split(",")
              .map((occupant) => occupant.trim())
              .toList(),
      "utilitiesAndServices": utilitiesController.text,
    };

    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(leaseData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lease registered successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register lease: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register Lease')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: tenantController,
              decoration: InputDecoration(labelText: 'Tenant ID'),
            ),
            TextField(
              controller: propertyController,
              decoration: InputDecoration(labelText: 'Property ID'),
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
              controller: rentAmountController,
              decoration: InputDecoration(labelText: 'Rent Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: securityDepositController,
              decoration: InputDecoration(labelText: 'Security Deposit'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: paymentDueDateController,
              decoration: InputDecoration(labelText: 'Payment Due Date'),
            ),
            TextField(
              controller: paymentMethodController,
              decoration: InputDecoration(labelText: 'Payment Method'),
            ),
            TextField(
              controller: rulesController,
              decoration: InputDecoration(labelText: 'Rules and Conditions'),
            ),
            TextField(
              controller: additionalOccupantsController,
              decoration: InputDecoration(
                labelText: 'Additional Occupants (comma separated)',
              ),
            ),
            TextField(
              controller: utilitiesController,
              decoration: InputDecoration(labelText: 'Utilities and Services'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : registerLease,
              child:
                  isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Register Lease'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: LeaseRegistrationScreen()));
}
