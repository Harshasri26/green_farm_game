import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cropController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController farmSizeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Farmer Profile')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Enter Name' : null,
              ),
              TextFormField(
                controller: cropController,
                decoration: InputDecoration(labelText: 'Crop'),
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextFormField(
                controller: farmSizeController,
                decoration: InputDecoration(labelText: 'Farm Size'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await LocalStorage.saveProfile({
                        'name': nameController.text,
                        'crop': cropController.text,
                        'location': locationController.text,
                        'farmSize': farmSizeController.text,
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  },
                  child: Text('Save & Continue'))
            ],
          ),
        ),
      ),
    );
  }
}
