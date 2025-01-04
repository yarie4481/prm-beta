import 'dart:convert';
import 'package:beta_pm/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Property1 {
  final String id;
  final String title;
  final String description;
  final String address;
  final int price;
  final int rentPrice;
  final int numberOfUnits;
  final String propertyType;
  final String floorPlan;
  final List<String> amenities;
  final List<String> photos;

  Property1({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.price,
    required this.rentPrice,
    required this.numberOfUnits,
    required this.propertyType,
    required this.floorPlan,
    required this.amenities,
    required this.photos,
  });

  factory Property1.fromJson(Map<String, dynamic> json) {
    return Property1(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? "",
      address: json['address'] ?? "",
      price: json['price'] ?? 0,
      rentPrice: json['rentPrice'] ?? 0,
      numberOfUnits: json['numberOfUnits'] ?? 0,
      propertyType: json['propertyType'] ?? "",
      floorPlan: json['floorPlan'] ?? "",
      amenities: List<String>.from(json['amenities'] ?? []),
      photos: List<String>.from(json['photos'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'address': address,
      'price': price,
      'rentPrice': rentPrice,
      'numberOfUnits': numberOfUnits,
      'propertyType': propertyType,
      'floorPlan': floorPlan,
      'amenities': amenities,
      'photos': photos,
    };
  }
}

class SuperUserController1 {
  static const String baseUrl =
      "https://pms-backend-sncw.onrender.com/api/v1/properties";

  Future<void> createProperty(Map<String, dynamic> propertyData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(propertyData),
      );

      if (response.statusCode == 201) {
        print('Property created successfully');
      } else {
        throw Exception('Failed to create property: ${response.body}');
      }
    } catch (e) {
      print('Error creating property: $e');
    }
  }
}

class AddPropertyScreen extends StatefulWidget {
  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _rentPriceController = TextEditingController();
  final _numberOfUnitsController = TextEditingController();
  final _propertyTypeController = TextEditingController();
  final _floorPlanController = TextEditingController();
  final _amenitiesController = TextEditingController();
  final _photosController = TextEditingController();

  bool _isLoading = false;

  String _propertyType = 'Residential';
  String _status = 'Available';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final propertyData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'address': _addressController.text,
        'price': int.parse(_priceController.text),
        'rentPrice': int.parse(_rentPriceController.text),
        'numberOfUnits': int.parse(_numberOfUnitsController.text),
        'propertyType': _propertyType,
        'floorPlan': _floorPlanController.text,
        'amenities': _amenitiesController.text.split(','),
        'photos': _photosController.text.split(','),
        'status': _status,
      };

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('No token found');
      }

      final url = Uri.parse(
        'https://pms-backend-sncw.onrender.com/api/v1/properties/create-property',
      );
      try {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(propertyData),
        );

        if (response.statusCode == 201) {
          print('Property created successfully');
        } else {
          throw Exception('Failed to create property: ${response.body}');
        }
      } catch (e) {
        print('Error creating property: $e');
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Property added successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Add Property'),
        backgroundColor: Colors.cyan.shade400,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create Property',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Property Title',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Title is required' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Description is required' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Address is required' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Price is required' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _rentPriceController,
                      decoration: InputDecoration(
                        labelText: 'Rent Price',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Rent Price is required' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _numberOfUnitsController,
                      decoration: InputDecoration(
                        labelText: 'Number of Units',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Number of Units is required'
                                  : null,
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _propertyType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _propertyType = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Property Type',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items:
                          ['Residential', 'Commercial', 'Industrial']
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                      validator:
                          (value) =>
                              value == null
                                  ? 'Property Type is required'
                                  : null,
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _status,
                      onChanged: (String? newValue) {
                        setState(() {
                          _status = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Status',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items:
                          ['Available', 'Not Available']
                              .map(
                                (status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ),
                              )
                              .toList(),
                      validator:
                          (value) =>
                              value == null ? 'Status is required' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _floorPlanController,
                      decoration: InputDecoration(
                        labelText: 'Floor Plan',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Floor Plan is required' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _amenitiesController,
                      decoration: InputDecoration(
                        labelText: 'Amenities (comma separated)',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Amenities are required' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _photosController,
                      decoration: InputDecoration(
                        labelText: 'Photos (comma separated URLs)',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Photos are required' : null,
                    ),
                    SizedBox(height: 16),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Add Property'),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
