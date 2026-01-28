import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import 'profile_screen.dart';

class LanguageScreen extends StatelessWidget {
  final List<String> languages = ['English', 'Hindi', 'Telugu'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Language')),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(languages[index]),
            onTap: () async {
              await LocalStorage.saveLanguage(languages[index]);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          );
        },
      ),
    );
  }
}
