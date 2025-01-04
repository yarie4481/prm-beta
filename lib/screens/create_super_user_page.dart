import 'package:beta_pm/screens/drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/super_user_controller.dart';

class CreateSuperUserPage extends StatefulWidget {
  @override
  _CreateSuperUserPageState createState() => _CreateSuperUserPageState();
}

class _CreateSuperUserPageState extends State<CreateSuperUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'SuperAdmin'; // Default role
  String _status = 'active'; // Default status
  bool _isLoading = false;
  final SuperUserController _controller = SuperUserController();

  void _createSuperUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final superUser = await _controller.createSuperUser(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _role,
        _status,
      );

      setState(() {
        _isLoading = false;
      });

      if (superUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User created: ${superUser.name}')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create User')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(251, 232, 229, 229),
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFF2575FC),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2575FC), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.person_add, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Add Users',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create User',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator:
                        (value) => value!.isEmpty ? 'Name is required' : null,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator:
                        (value) => value!.isEmpty ? 'Email is required' : null,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Password is required' : null,
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _role,
                    onChanged: (String? newValue) {
                      setState(() {
                        _role = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Role',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items:
                        ['SuperAdmin', 'Admin', 'User']
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ),
                            )
                            .toList(),
                    validator:
                        (value) => value == null ? 'Role is required' : null,
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
                        ['active', 'inactive']
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ),
                            )
                            .toList(),
                    validator:
                        (value) => value == null ? 'Status is required' : null,
                  ),
                  SizedBox(height: 16),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _createSuperUser,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent, // Text color
                          elevation: 5, // Shadow depth
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 36,
                          ), // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // Rounded corners
                          ),
                        ),
                        child: Text(
                          'Create SuperUser',
                          style: TextStyle(
                            fontSize: 18, // Text size
                            fontWeight: FontWeight.bold, // Bold text
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
