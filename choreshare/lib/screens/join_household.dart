import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/profile.dart';
import '../models/chore.dart';
import '../main.dart';

class JoinHouseholdScreen extends StatelessWidget {
  final _householdIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Household'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _householdIdController,
              decoration: InputDecoration(labelText: 'Enter your household ID'),
            ),
            ElevatedButton(
              onPressed: () async {
                final id = _householdIdController.text;
                if (id.isNotEmpty) {
                  // Assuming the household ID is used to retrieve data from a remote server
                  // For simplicity, we just check if profiles or chores exist in the local database
                  final profiles = await Provider.of<ChoreShareDatabase>(context, listen: false).getProfiles();
                  final chores = await Provider.of<ChoreShareDatabase>(context, listen: false).getChores();
                  
                  if (profiles.isNotEmpty || chores.isNotEmpty) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  } else {
                    // Show error if no data is found
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('No household found with this ID'),
                    ));
                  }
                }
              },
              child: Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}

