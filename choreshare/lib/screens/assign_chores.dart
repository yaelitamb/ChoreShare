import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/chore.dart';
import '../models/profile.dart';

class AssignChoresScreen extends StatefulWidget {
  final List<Chore> chores;

  AssignChoresScreen({required this.chores});

  @override
  _AssignChoresScreenState createState() => _AssignChoresScreenState();
}

class _AssignChoresScreenState extends State<AssignChoresScreen> {
  late List<Profile> _profiles;
  late List<bool> _selectedProfiles;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    _profiles = await Provider.of<ChoreShareDatabase>(context, listen: false).getProfiles();
    _selectedProfiles = List<bool>.filled(_profiles.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Chores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.chores.length,
          itemBuilder: (context, index) {
            final chore = widget.chores[index];
            return ListTile(
              title: Text(chore.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignChoreDetailScreen(chore: chore, profiles: _profiles),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AssignChoreDetailScreen extends StatefulWidget {
  final Chore chore;
  final List<Profile> profiles;

  AssignChoreDetailScreen({required this.chore, required this.profiles});

  @override
  _AssignChoreDetailScreenState createState() => _AssignChoreDetailScreenState();
}

class _AssignChoreDetailScreenState extends State<AssignChoreDetailScreen> {
  late List<bool> _selectedProfiles;

  @override
  void initState() {
    super.initState();
    _selectedProfiles = List<bool>.filled(widget.profiles.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Chore: ${widget.chore.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Assign Profiles:'),
            Expanded(
              child: ListView.builder(
                itemCount: widget.profiles.length,
                itemBuilder: (context, index) {
                  final profile = widget.profiles[index];
                  return CheckboxListTile(
                    title: Text(profile.name),
                    value: _selectedProfiles[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedProfiles[index] = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle assigning profiles to chore here
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
