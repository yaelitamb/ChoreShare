import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '/models/profile.dart';
import '/models/chore.dart';
import '../database.dart';

class HouseholdScreen extends StatefulWidget {
  @override
  _HouseholdScreenState createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends State<HouseholdScreen> {
  Map<DateTime, List<Chore>> _events = {};
  DateTime _selectedDay = DateTime.now();
  List<Chore> _selectedChores = [];

  @override
  void initState() {
    super.initState();
    _loadChores();
  }

  Future<void> _loadChores() async {
    final db = Provider.of<ChoreShareDatabase>(context, listen: false);
    final chores = await db.getChores();
    setState(() {
      _events = _generateEvents(chores);
    });
  }

  Map<DateTime, List<Chore>> _generateEvents(List<Chore> chores) {
    Map<DateTime, List<Chore>> events = {};
    for (var chore in chores) {
      for (var day in chore.days) {
        DateTime date = _getDateFromDayString(day);
        if (events.containsKey(date)) {
          events[date]!.add(chore);
        } else {
          events[date] = [chore];
        }
      }
    }
    return events;
  }

  DateTime _getDateFromDayString(String day) {
    int currentWeekday = DateTime.now().weekday;
    int targetWeekday = _getWeekdayFromString(day);
    int difference = targetWeekday - currentWeekday;
    if (difference < 0) difference += 7;
    return DateTime.now().add(Duration(days: difference));
  }

  int _getWeekdayFromString(String day) {
    switch (day) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Household Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            eventLoader: (day) => _events[day] ?? [],
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _selectedChores = _events[selectedDay] ?? [];
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildMarkers(events),
                  );
                }
                return SizedBox();
              },
            ),
          ),
          ..._selectedChores.map(
            (chore) => ListTile(
              title: Text(chore.name),
              subtitle: Text(chore.description),
              trailing: Text(chore.assignedProfiles.join(', ')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkers(List<dynamic> events) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: events.map((event) {
        final chore = event as Chore;
        return FutureBuilder<Profile>(
          future: Provider.of<ChoreShareDatabase>(context, listen: false)
              .getProfile(chore.assignedProfiles.first),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: 7.0,
                height: 7.0,
                margin: const EdgeInsets.symmetric(horizontal: 0.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                width: 7.0,
                height: 7.0,
                margin: const EdgeInsets.symmetric(horizontal: 0.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              );
            } else {
              final profile = snapshot.data!;
              return Container(
                width: 7.0,
                height: 7.0,
                margin: const EdgeInsets.symmetric(horizontal: 0.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(int.parse(profile.color)),
                ),
              );
            }
          },
        );
      }).toList(),
    );
  }
}
