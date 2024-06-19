import 'package:flutter/material.dart';
import '../main.dart';

class JoinHouseholdScreen extends StatelessWidget {
  const JoinHouseholdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Existing Household'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter your household ID',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()), // Asegúrate de tener MainScreen en main.dart
                );
              },
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
