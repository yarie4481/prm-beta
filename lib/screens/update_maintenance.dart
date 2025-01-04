import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UpdateRequestScreen extends StatefulWidget {
  final Map<String, dynamic> request;

  const UpdateRequestScreen({Key? key, required this.request})
    : super(key: key);

  @override
  _UpdateRequestScreenState createState() => _UpdateRequestScreenState();
}

class _UpdateRequestScreenState extends State<UpdateRequestScreen> {
  late TextEditingController tenantNameController;
  late TextEditingController typeOfRequestController;
  late TextEditingController descriptionController;
  late TextEditingController urgencyLevelController;
  late TextEditingController propertyTitleController;
  late TextEditingController preferredAccessTimesController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tenantNameController = TextEditingController(
      text:
          widget.request['tenant'] != null
              ? widget.request['tenant']['tenantName']?.toString() ?? ''
              : '',
    );
    typeOfRequestController = TextEditingController(
      text: widget.request['typeOfRequest']?.toString() ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.request['description']?.toString() ?? '',
    );
    urgencyLevelController = TextEditingController(
      text: widget.request['urgencyLevel']?.toString() ?? '',
    );
    propertyTitleController = TextEditingController(
      text:
          widget.request['property'] != null
              ? widget.request['property']['title']?.toString() ?? ''
              : '',
    );
    preferredAccessTimesController = TextEditingController(
      text: widget.request['preferredAccessTimes']?.toString() ?? '',
    );
  }

  Future<void> updateRequest() async {
    setState(() {
      isLoading = true;
    });

    final url =
        'https://pms-backend-sncw.onrender.com/api/v1/maintenances/${widget.request['_id']}';
    final updatedData = {
      'tenantName': tenantNameController.text.trim(),
      'typeOfRequest': typeOfRequestController.text.trim(),
      'description': descriptionController.text.trim(),
      'urgencyLevel': urgencyLevelController.text.trim(),
      'propertyTitle': propertyTitleController.text.trim(),
      'preferredAccessTimes': preferredAccessTimesController.text.trim(),
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        final updatedRequest = json.decode(response.body);
        Navigator.pop(context, updatedRequest['data']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request updated successfully')),
        );
      } else {
        throw Exception('Failed to update request');
      }
    } catch (error) {
      print('Error updating request: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update request')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Maintenance Request'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: tenantNameController,
                decoration: const InputDecoration(labelText: 'Tenant Name'),
              ),
              TextField(
                controller: typeOfRequestController,
                decoration: const InputDecoration(labelText: 'Type of Request'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: urgencyLevelController,
                decoration: const InputDecoration(labelText: 'Urgency Level'),
              ),
              TextField(
                controller: propertyTitleController,
                decoration: const InputDecoration(labelText: 'Property Title'),
              ),
              TextField(
                controller: preferredAccessTimesController,
                decoration: const InputDecoration(
                  labelText: 'Preferred Access Times',
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: updateRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Update Request',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
