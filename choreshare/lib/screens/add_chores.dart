import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/chore.dart';
import 'assign_chores.dart';

class AddChoresScreen extends StatefulWidget {
  @override
  _AddChoresScreenState createState() => _AddChoresScreenState();
}

class _AddChoresScreenState extends State<AddChoresScreen> {
  final List<String> _defaultChores = ['Dishes', 'Laundry', 'Make bed', 'Vacuum'];
  final List<Chore> _chores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Chores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _defaultChores.map((chore) {
                  return CheckboxListTile(
                    title: Text(chore),
                    value: _chores.any((c) => c.name == chore),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _chores.add(Chore(
                            id: 0,
                            name: chore,
                            description: '',
                            assignedProfiles: [],
                            rotation: false,
                            repetition: 'Daily',
                            every: 'Week',
                            days: [],
                          ));
                        } else {
                          _chores.removeWhere((c) => c.name == chore);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateChoreScreen(onSave: (chore) {
                    setState(() {
                      _chores.add(chore);
                    });
                  })),
                );
              },
              child: Text('Create your own chore'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssignChoresScreen(chores: _chores)),
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

class CreateChoreScreen extends StatefulWidget {
  final Function(Chore) onSave;

  CreateChoreScreen({required this.onSave});

  @override
  _CreateChoreScreenState createState() => _CreateChoreScreenState();
}

class _CreateChoreScreenState extends State<CreateChoreScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Chore'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  final chore = Chore(
                    id: 0,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    assignedProfiles: [],
                    rotation: false,
                    repetition: 'Daily',
                    every: 'Week',
                    days: [],
                  );
                  widget.onSave(chore);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
