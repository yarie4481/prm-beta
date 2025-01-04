import 'package:beta_pm/screens/add_lease.dart';
import 'package:beta_pm/screens/maintaenance.dart';
import 'package:beta_pm/screens/tenant_list_page.dart';
import 'package:beta_pm/screens/view_lease.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:beta_pm/screens/addProperty.dart';
import 'package:beta_pm/screens/property_list_page.dart';
import 'package:beta_pm/screens/super_user_list_page.dart';
import 'package:beta_pm/screens/login_page.dart'; // Import your LoginPage here.

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isUserExpanded = false;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the token from shared preferences
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ), // Navigate to LoginPage
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.8),
            colors: [Colors.cyan.shade700, Colors.blue.shade900],
            radius: 1.2,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, User!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('User', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.person, color: Colors.white),
              trailing: Icon(
                isUserExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  isUserExpanded = !isUserExpanded;
                });
              },
            ),
            if (isUserExpanded) ...[
              ListTile(
                title: Text('All User', style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuperUserListPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Admin', style: TextStyle(color: Colors.white)),
                leading: Icon(Icons.admin_panel_settings, color: Colors.white),
                onTap: () {
                  // Handle Admin
                },
              ),
              ListTile(
                title: Text('User', style: TextStyle(color: Colors.white)),
                leading: Icon(Icons.person_outline, color: Colors.white),
                onTap: () {
                  // Handle User
                },
              ),
            ],
            ListTile(
              title: Text('Property', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.home, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PropertyListPage()),
                );
              },
            ),
            ListTile(
              title: Text('Tenant', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.people, color: Colors.white),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TenantListPage()),
                );
              },
            ),

            ListTile(
              title: Text('Agreement', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.description, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeaseListScreen()),
                );
              },
            ),

            ListTile(
              title: Text(
                'Maintenance Requests',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(Icons.description, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaintenanceRequestsScreen(),
                  ),
                );
              },
            ),
            Divider(color: Colors.white70),
            ListTile(
              title: Text('Logout', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.logout, color: Colors.white),
              onTap: _logout, // Call the _logout function
            ),
          ],
        ),
      ),
    );
  }
}
