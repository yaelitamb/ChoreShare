import 'package:flutter/material.dart';
import '../main.dart'; // Asegúrate de que MainScreen esté importado correctamente.

class JoinHouseholdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Household'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          child: Text('Join'),
        ),
      ),
    );
  }
}
