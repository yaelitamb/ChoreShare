import 'package:flutter/material.dart';
import '../models/chore.dart';
import '../models/profile.dart';
import '../database.dart';
import 'package:provider/provider.dart';

class AssignChoresScreen extends StatefulWidget {
  final List<Chore> chores;

  AssignChoresScreen({required this.chores});

  @override
  _AssignChoresScreenState createState() => _AssignChoresScreenState();
}

class _AssignChoresScreenState extends State<AssignChoresScreen> {
  final Map<int, List<Profile>> _choreAssignments = {};
  final Map<int, List<bool>> _choreDays = {};

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<ChoreShareDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Chores'),
      ),
      body: ListView.builder(
        itemCount: widget.chores.length,
        itemBuilder: (context, index) {
          final chore = widget.chores[index];
          return ListTile(
            title: Text(chore.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Assigned to: ${_choreAssignments[chore.id]?.map((profile) => profile.name).join(', ') ?? 'None'}'),
                Text('Days: ${_choreDays[chore.id]?.asMap().entries.where((entry) => entry.value).map((entry) => ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][entry.key]).join(', ') ?? 'None'}'),
              ],
            ),
            onTap: () async {
              final selectedProfiles = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSelectionScreen()),
              );
              final selectedDays = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DaySelectionScreen()),
              );
              if (selectedProfiles != null && selectedDays != null) {
                setState(() {
                  _choreAssignments[chore.id] = selectedProfiles;
                  _choreDays[chore.id] = selectedDays;
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          for (final chore in widget.chores) {
            if (_choreAssignments.containsKey(chore.id) && _choreDays.containsKey(chore.id)) {
              final updatedChore = chore.copyWith(
                assignedProfiles: _choreAssignments[chore.id]!,
                days: _choreDays[chore.id]!.asMap().entries.where((entry) => entry.value).map((entry) => entry.key).toList(),
              );
              await db.updateChore(updatedChore);
            }
          }
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

class ProfileSelectionScreen extends StatefulWidget {
  @override
  _ProfileSelectionScreenState createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  final List<Profile> selectedProfiles = [];

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<ChoreShareDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Profiles'),
      ),
      body: FutureBuilder<List<Profile>>(
        future: db.getProfiles(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final profiles = snapshot.data!;

          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return CheckboxListTile(
                title: Text(profile.name),
                value: selectedProfiles.contains(profile),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedProfiles.add(profile);
                    } else {
                      selectedProfiles.remove(profile);
                    }
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedProfiles);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class DaySelectionScreen extends StatefulWidget {
  @override
  _DaySelectionScreenState createState() => _DaySelectionScreenState();
}

class _DaySelectionScreenState extends State<DaySelectionScreen> {
  final _selectedDays = List<bool>.filled(7, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Days'),
      ),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][index]),
            value: _selectedDays[index],
            onChanged: (bool? value) {
              setState(() {
                _selectedDays[index] = value!;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedDays);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
