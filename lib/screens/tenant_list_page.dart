import 'package:beta_pm/screens/addTenat.dart';
import 'package:beta_pm/screens/tenant_form_page.dart';
import 'package:flutter/material.dart';
import '../controllers/tenant_controller.dart';

class TenantListPage extends StatefulWidget {
  const TenantListPage({Key? key}) : super(key: key);

  @override
  _TenantListPageState createState() => _TenantListPageState();
}

class _TenantListPageState extends State<TenantListPage> {
  late TenantService tenantService;
  late Future<List<dynamic>> tenants;

  @override
  void initState() {
    super.initState();

    tenantService = TenantService(); // Replace <token> with your token.
    tenants = tenantService.fetchTenants(); // No type mismatch now
  }

  void refreshTenants() {
    setState(() {
      tenants = tenantService.fetchTenants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tenants',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent, // Change to a gradient if desired
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTenantScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: tenants,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Failed to load tenants'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final tenants = snapshot.data!;
              return ListView.builder(
                itemCount: tenants.length,
                itemBuilder: (context, index) {
                  final tenant = tenants[index];
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
                        title: Text(tenant['tenantName'].trim()),
                        subtitle: Text(
                          tenant['contactInformation']['email'].trim(),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TenantFormPage(
                                          tenant: tenant,
                                          refreshTenants: refreshTenants,
                                        ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await tenantService.deleteTenant(tenant['_id']);
                                refreshTenants();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No tenants found'));
            }
          },
        ),
      ),
    );
  }
}
