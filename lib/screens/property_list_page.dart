import 'package:beta_pm/controllers/super_user_controller.dart';
import 'package:beta_pm/models/property_model.dart';
import 'package:beta_pm/screens/addProperty.dart';
import 'package:beta_pm/screens/drawer.dart';
import 'package:flutter/material.dart';

class PropertyListPage extends StatefulWidget {
  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  final SuperUserController _controller = SuperUserController();
  late Future<List<Property>> _properties;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  void _loadProperties() {
    setState(() {
      _properties = _controller.fetchProperties();
    });
  }

  Future<void> _deleteProperty(String id) async {
    try {
      await _controller.deleteProperty(id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Property deleted successfully!')));
      _loadProperties();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting property: $e')));
    }
  }

  Future<void> _editProperty(Property property) async {
    // Initialize controllers with existing property data
    TextEditingController titleController = TextEditingController(
      text: property.title,
    );
    TextEditingController addressController = TextEditingController(
      text: property.address,
    );
    TextEditingController priceController = TextEditingController(
      text: property.price.toString(),
    );
    TextEditingController rentPriceController = TextEditingController(
      text: property.rentPrice.toString(),
    );
    String selectedPropertyType = property.propertyType;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Property'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: rentPriceController,
                  decoration: InputDecoration(labelText: 'Rent Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                DropdownButton<String>(
                  value: selectedPropertyType,
                  items:
                      ['Apartment', 'House', 'Office'] // Example property types
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedPropertyType = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                try {
                  await _controller.updateProperty(property.id, {
                    'title': titleController.text,
                    'address': addressController.text,
                    'price':
                        double.tryParse(priceController.text) ?? property.price,
                    'rentPrice':
                        double.tryParse(rentPriceController.text) ??
                        property.rentPrice,
                    'propertyType': selectedPropertyType,
                  });

                  _loadProperties(); // Refresh the property list after update
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Property updated successfully!')),
                  );
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating property: $e')),
                    );
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(251, 232, 229, 229),

      drawer: CustomDrawer(),

      appBar: AppBar(
        title: Text('Properties'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Container(
        child: FutureBuilder<List<Property>>(
          future: _properties,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Properties found.'));
            }

            final properties = snapshot.data!;
            return ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.white70],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(20),
                      title: Text(
                        property.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1.2,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${property.propertyType} | ${property.address}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Price: ${property.price} | Rent: ${property.rentPrice}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.green,
                              size: 24,
                            ),
                            onPressed: () {
                              _editProperty(property);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 24,
                            ),
                            onPressed: () {
                              _deleteProperty(property.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPropertyScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
