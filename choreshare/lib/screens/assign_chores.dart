import 'package:flutter/material.dart';
import '../models/chore.dart';
import '../database.dart';

class AssignChoresScreen extends StatefulWidget {
  @override
  _AssignChoresScreenState createState() => _AssignChoresScreenState();
}

class _AssignChoresScreenState extends State<AssignChoresScreen> {
  List<Chore> _chores = [];
  Chore? _selectedChore;

  @override
  void initState() {
    super.initState();
    _loadChores();
  }

  Future<void> _loadChores() async {
    final chores = await ChoreShareDatabase.instance.getChores();
    setState(() {
      _chores = chores;
    });
  }

  void _updateChore(Chore chore, String newRepetition) {
    final updatedChore = Chore(
      id: chore.id,
      name: chore.name,
      description: chore.description,
      assignedProfiles: chore.assignedProfiles,
      rotation: chore.rotation,
      repetition: newRepetition,
      every: chore.every,
      days: chore.days,
    );

    // Aquí puedes guardar el updatedChore en la base de datos si es necesario
    ChoreShareDatabase.instance.insertChore(updatedChore);

    setState(() {
      _chores[_chores.indexWhere((c) => c.id == chore.id)] = updatedChore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Chores'),
      ),
      body: ListView.builder(
        itemCount: _chores.length,
        itemBuilder: (context, index) {
          final chore = _chores[index];
          return ListTile(
            title: Text(chore.name),
            onTap: () {
              setState(() {
                _selectedChore = chore;
              });
              _showEditDialog(chore);
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(Chore chore) {
    String newRepetition = chore.repetition;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Chore'),
          content: TextField(
            onChanged: (value) {
              newRepetition = value;
            },
            decoration: InputDecoration(labelText: 'Repetition'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateChore(chore, newRepetition);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
