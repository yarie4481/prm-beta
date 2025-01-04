import 'package:beta_pm/controllers/super_user_controller.dart';
import 'package:beta_pm/models/super_user_model.dart';
import 'package:beta_pm/screens/create_super_user_page.dart';
import 'package:beta_pm/screens/drawer.dart';
import 'package:flutter/material.dart';

class SuperUserListPage extends StatefulWidget {
  @override
  _SuperUserListPageState createState() => _SuperUserListPageState();
}

class _SuperUserListPageState extends State<SuperUserListPage> {
  final SuperUserController _controller = SuperUserController();
  late Future<List<SuperUser>> _superUsers;
  String _selectedRole = 'All'; // Default role filter

  @override
  void initState() {
    super.initState();
    _loadSuperUsers();
  }

  void _loadSuperUsers() {
    setState(() {
      _superUsers = _controller.fetchSuperUsers();
    });
  }

  Future<void> _deleteSuperUser(String id) async {
    try {
      await _controller.deleteSuperUser(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SuperUser deleted successfully!')),
      );
      _loadSuperUsers(); // Refresh the list after deletion
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting SuperUser: $e')));
    }
  }

  Future<void> _editSuperUser(SuperUser user) async {
    // Show a dialog for editing user details
    TextEditingController nameController = TextEditingController(
      text: user.name,
    );
    TextEditingController emailController = TextEditingController(
      text: user.email,
    );
    String selectedStatus = user.status;
    String selectedRole = user.role;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit  ${user.name}'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              DropdownButton<String>(
                value: selectedStatus,

                items:
                    ['active', 'inactive']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedStatus = value;
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items:
                    ['SuperAdmin', 'Admin', 'User', 'Tenant']
                        .map(
                          (role) =>
                              DropdownMenuItem(value: role, child: Text(role)),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedRole = value;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _controller.updateSuperUser(user.id, {
                    'name': nameController.text,
                    'email': emailController.text,
                    'status': selectedStatus,
                    'role': selectedRole,
                  });

                  _loadSuperUsers(); // Refresh the list after update
                } catch (e) {
                  if (mounted) {
                    Text('Error updating SuperUser: $e');
                    print(e);
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
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Color.fromARGB(251, 232, 229, 229),
        drawer: CustomDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2575FC), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: AppBar(
              title: Text(
                'All Users',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              bottom: TabBar(
                isScrollable: true,
                labelColor: Colors.white, // Set active tab text color
                unselectedLabelColor: Colors.white54,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'SuperAdmin'),
                  Tab(text: 'Admin'),
                  Tab(text: 'Tenant'),
                  Tab(text: 'User'),
                ],
                onTap: (index) {
                  // Update selected role based on tab selection
                  setState(() {
                    _selectedRole =
                        index == 0
                            ? 'All'
                            : ['SuperAdmin', 'Admin', 'Tenant', 'User'][index -
                                1];
                  });
                },
              ),
              backgroundColor:
                  Colors.transparent, // Make the AppBar transparent
            ),
          ),
        ),
        body: Container(
          child: FutureBuilder<List<SuperUser>>(
            future: _superUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No SuperUsers found.'));
              }

              // Filter users based on selected role
              final superUsers =
                  snapshot.data!.where((user) {
                    return _selectedRole == 'All' || user.role == _selectedRole;
                  }).toList();

              return superUsers.isEmpty
                  ? Center(child: Text('No users found for $_selectedRole.'))
                  : ListView.builder(
                    itemCount: superUsers.length,
                    itemBuilder: (context, index) {
                      final user = superUsers[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        // elevation: 8,
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
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              user.name,
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
                                  '${user.role} | ${user.status}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                if (user.phoneNumber != null)
                                  Text(
                                    'Phone: ${user.phoneNumber}',
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
                                    // Handle user edit
                                    _editSuperUser(user);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    _deleteSuperUser(user.id);
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
              MaterialPageRoute(builder: (context) => CreateSuperUserPage()),
            );
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}
