import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    var profile = await LocalStorage.getProfile();
    setState(() {
      name = profile['name'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, $name', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Today\'s Mission',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Water your crops for 10 mins 🌱'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
