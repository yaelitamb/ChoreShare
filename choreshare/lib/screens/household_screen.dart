import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/profile.dart';
import '../models/chore.dart';

class HouseholdScreen extends StatefulWidget {
  const HouseholdScreen({super.key});

  @override
  _HouseholdScreenState createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends State<HouseholdScreen> {
  List<Profile> _profiles = [];
  List<Chore> _chores = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profiles = await Provider.of<ChoreShareDatabase>(context, listen: false).getProfiles();
    final chores = await Provider.of<ChoreShareDatabase>(context, listen: false).getChores();

    setState(() {
      _profiles = profiles;
      _chores = chores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household'),
      ),
      body: ListView.builder(
        itemCount: _profiles.length,
        itemBuilder: (context, index) {
          final profile = _profiles[index];
          final assignedChores = _chores.where((chore) => chore.assignedProfiles.contains(profile.id)).toList();

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Text(profile.name[0]),
            ),
            title: Text(profile.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: assignedChores.map((chore) => Text(chore.name)).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add profile screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
