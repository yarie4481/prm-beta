import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class AddTenantScreen extends StatefulWidget {
  @override
  _AddTenantScreenState createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends State<AddTenantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tenantNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _rentAmountController = TextEditingController();
  final _securityDepositController = TextEditingController();
  final _unitController = TextEditingController();
  final _propertyIdController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _moveInDateController = TextEditingController();

  bool _isLoading = false;
  List<Map<String, String>> _selectedFiles = [];

  final url = Uri.parse('http://192.168.1.4:4000/api/v1/tenants');

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final filePayload = await _prepareFilePayload(); // Get file payload

      final payload = {
        "tenantName": _tenantNameController.text,
        "contactInformation": {
          "email": _emailController.text,
          "phoneNumber": _phoneNumberController.text,
          "emergencyContact": _emergencyContactController.text,
        },
        "leaseAgreement": {
          "startDate": _startDateController.text,
          "endDate": _endDateController.text,
          "rentAmount": int.parse(_rentAmountController.text),
          "securityDeposit": int.parse(_securityDepositController.text),
          "specialTerms": "No pets allowed",
        },
        "propertyInformation": {
          "unit": _unitController.text,
          "propertyId": "676015c5d1b4a0414087c69e",
        },
        "password": "password123",
        "paymentMethod": _paymentMethodController.text,
        "moveInDate": _moveInDateController.text,
        "emergencyContacts": [
          _emergencyContactController.text,
          _phoneNumberController.text,
        ],
        "idProof": filePayload, // include file payload here
      };

      print(payload);
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Tenant added successfully!')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add tenant: ${response.body},'),
            duration: Duration(seconds: 50), // Set duration to 50 seconds
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, String>>> _prepareFilePayload() async {
    List<Map<String, String>> filePayload = [];
    for (var fileMap in _selectedFiles) {
      var filePath = fileMap['path'];
      if (filePath != null) {
        File file = File(filePath);
        List<int> bytes = await file.readAsBytes();
        String base64Image = base64Encode(bytes);
        filePayload.add({
          "fieldname": 'idProof',
          "originalname": path.basename(filePath.toString()),
          "fileType": fileMap['fileType'] ?? "jpg",
          "base64Data": base64Image,
        });
      }
    }
    return filePayload;
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      List<Map<String, String>> selectedFiles =
          result.files.map((file) {
            return {
              'fieldname': 'idProof',
              'fileName': path.basename(file.path!),
              'path': file.path!,
              'fileType': file.extension ?? 'jpg',
            };
          }).toList();

      setState(() {
        _selectedFiles = selectedFiles;
      });
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Tenant')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_tenantNameController, 'Tenant Name'),
                _buildTextField(_emailController, 'Email'),
                _buildTextField(_phoneNumberController, 'Phone Number'),
                _buildTextField(
                  _emergencyContactController,
                  'Emergency Contact',
                ),
                _buildDateField(
                  _startDateController,
                  'Lease Start Date',
                  context,
                ),
                _buildDateField(_endDateController, 'Lease End Date', context),
                _buildTextField(
                  _rentAmountController,
                  'Rent Amount',
                  isNumber: true,
                ),
                _buildTextField(
                  _securityDepositController,
                  'Security Deposit',
                  isNumber: true,
                ),
                _buildTextField(_unitController, 'Unit'),
                _buildTextField(_propertyIdController, 'Property ID'),
                _buildTextField(_paymentMethodController, 'Payment Method'),
                _buildDateField(_moveInDateController, 'Move-in Date', context),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickFiles,
                  child: Text('Select Files'),
                ),
                SizedBox(height: 16),
                _selectedFiles.isNotEmpty
                    ? Text('${_selectedFiles.length} files selected')
                    : Text('No files selected'),
                SizedBox(height: 16),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) => value!.isEmpty ? '$label is required' : null,
      ),
    );
  }

  Widget _buildDateField(
    TextEditingController controller,
    String label,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context, controller),
        validator: (value) => value!.isEmpty ? '$label is required' : null,
      ),
    );
  }
}
