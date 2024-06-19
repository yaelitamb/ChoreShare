import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/chore.dart';
import '../models/profile.dart';
import 'household_screen.dart';

class AssignChoresScreen extends StatefulWidget {
  final List<Chore> chores;

  const AssignChoresScreen({Key? key, required this.chores}) : super(key: key);

  @override
  _AssignChoresScreenState createState() => _AssignChoresScreenState();
}

class _AssignChoresScreenState extends State<AssignChoresScreen> {
  late List<Profile> _profiles;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    _profiles = await Provider.of<ChoreShareDatabase>(context, listen: false).getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Chores'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HouseholdScreen()),
          );
        },
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}


class AssignChoreDetailScreen extends StatefulWidget {
  final Chore chore;
  final List<Profile> profiles;

  const AssignChoreDetailScreen({Key? key, required this.chore, required this.profiles}) : super(key: key);

  @override
  _AssignChoreDetailScreenState createState() => _AssignChoreDetailScreenState();
}

class _AssignChoreDetailScreenState extends State<AssignChoreDetailScreen> {
  late List<bool> _selectedProfiles;
  late List<bool> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedProfiles = List<bool>.filled(widget.profiles.length, false);
    _selectedDays = List<bool>.generate(7, (index) => false); // Para los 7 días de la semana
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
            const Text('Assign Profiles:'),
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
            const Text('Assign Days:'),
            Wrap(
              spacing: 8.0,
              children: List.generate(7, (index) {
                return ChoiceChip(
                  label: Text(getDayName(index)), // Función auxiliar para obtener el nombre del día
                  selected: _selectedDays[index],
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedDays[index] = selected;
                    });
                  },
                );
              }),
            ),
            ElevatedButton(
              onPressed: () {
                // Guardar la asignación de perfiles y días aquí
                List<int> selectedProfileIds = [];
                for (int i = 0; i < _selectedProfiles.length; i++) {
                  if (_selectedProfiles[i]) {
                    selectedProfileIds.add(widget.profiles[i].id);
                  }
                }
                List<String> selectedDays = [];
                for (int i = 0; i < _selectedDays.length; i++) {
                  if (_selectedDays[i]) {
                    selectedDays.add(getDayName(i)); // Agregar el nombre del día seleccionado
                  }
                }
                // Guardar la información de asignación aquí

                Navigator.pop(context); // Volver a la pantalla anterior
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  String getDayName(int index) {
    // Función para obtener el nombre del día dado el índice (0-6)
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return '';
    }
  }
}
