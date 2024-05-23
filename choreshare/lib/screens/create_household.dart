import 'package:flutter/material.dart';
import 'add_profile.dart';
import 'add_chores.dart';

class CreateHouseholdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Household'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Add profiles'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProfileScreen()),
                );
              },
              child: Text('Add profile'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddChoresScreen()),
                );
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
