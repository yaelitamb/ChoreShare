import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/profile.dart';
import '../models/chore.dart';
import 'add_profile.dart'; // Asegúrate de importar la pantalla AddProfileScreen
import 'add_chores.dart'; // Asegúrate de importar la pantalla AddChoresScreen
import 'done_screen.dart'; // Asegúrate de importar la pantalla DoneScreen
import 'package:table_calendar/table_calendar.dart'; // Importa el paquete necesario para el calendario

class HouseholdScreen extends StatefulWidget {
  const HouseholdScreen({Key? key}) : super(key: key);

  @override
  _HouseholdScreenState createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends State<HouseholdScreen> {
  List<Profile> _profiles = [];
  List<Chore> _chores = [];

  // Variables para el calendario
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<dynamic>> _events = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProfileScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(8),
        child: TableCalendar(
          firstDay: DateTime.utc(2023, 01, 01),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // actualizar `_focusedDay` también
            });
            // Lógica para cargar eventos para `selectedDay` y actualizar `_events` si es necesario
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
            // Retorna eventos para el día dado desde el mapa `_events`
            return _events[day] ?? [];
          },
        ),
      ),
    );
  }
}
