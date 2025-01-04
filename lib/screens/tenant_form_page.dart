import 'package:beta_pm/controllers/tenant_controller.dart';
import 'package:flutter/material.dart';

class TenantFormPage extends StatefulWidget {
  final Map<String, dynamic>? tenant;
  final VoidCallback refreshTenants;

  const TenantFormPage({Key? key, this.tenant, required this.refreshTenants})
    : super(key: key);

  @override
  _TenantFormPageState createState() => _TenantFormPageState();
}

class _TenantFormPageState extends State<TenantFormPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> tenantData = {};

  late TenantService tenantService;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tenantService = TenantService();

    if (widget.tenant != null) {
      tenantData.addAll(widget.tenant!);
    }
  }

  Future<void> handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      try {
        if (widget.tenant == null) {
          await tenantService.createTenant(tenantData);
        } else {
          await tenantService.updateTenant(widget.tenant!['_id'], tenantData);
        }
        widget.refreshTenants();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,

        title: Text(widget.tenant == null ? 'Create Tenant' : 'Update Tenant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Tenant Name Field
              TextFormField(
                initialValue: tenantData['tenantName'] ?? '',
                decoration: const InputDecoration(labelText: 'Tenant Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tenant Name is required';
                  }
                  return null;
                },
                onSaved: (value) => tenantData['tenantName'] = value!,
              ),
              // Email Field
              TextFormField(
                initialValue: tenantData['contactInformation']?['email'] ?? '',
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  tenantData['contactInformation'] ??= {};
                  tenantData['contactInformation']['email'] = value!;
                },
              ),
              // Lease Start Date Field
              TextFormField(
                initialValue: tenantData['leaseAgreement']?['startDate'] ?? '',
                decoration: const InputDecoration(
                  labelText: 'Lease Start Date (YYYY-MM-DD)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lease Start Date is required';
                  }
                  // Basic date validation (can be enhanced)
                  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                    return 'Enter a valid date (YYYY-MM-DD)';
                  }
                  return null;
                },
                onSaved: (value) {
                  tenantData['leaseAgreement'] ??= {};
                  tenantData['leaseAgreement']['startDate'] = value!;
                },
              ),
              // Additional fields can go here
              const SizedBox(height: 20),
              // Submit Button
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent, // Text color
                      elevation: 5, // Shadow depth
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Rounded corners
                      ),
                    ),

                    onPressed: handleSubmit,
                    child: Text(widget.tenant == null ? 'Create' : 'Update'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
