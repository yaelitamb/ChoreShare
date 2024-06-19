import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database.dart';
import 'screens/create_household.dart';
import 'screens/join_household.dart';
import 'screens/household_screen.dart';
import 'screens/chores_screen.dart';
import 'screens/done_screen.dart';
import 'screens/add_chores.dart';
import 'screens/assign_chores.dart';
import 'models/chore.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChoreShareDatabase.instance,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChoreShare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    await _player.setLoopMode(LoopMode.one);
    await _player.setAsset('assets/background.mp3');
    _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChoreShare'),
      ),
      body: FutureBuilder<List<Chore>>(
        future: Provider.of<ChoreShareDatabase>(context).getChores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final chores = snapshot.data!;
          return CalendarScreen(chores: chores);
        },
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  final List<Chore> chores;

  CalendarScreen({required this.chores});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Column(
      children: [
        // Implement your calendar view here
        Expanded(
          child: ListView.builder(
            itemCount: chores.length,
            itemBuilder: (context, index) {
              final chore = chores[index];
              final assignedProfiles = chore.assignedProfiles.map((profile) => profile.name).join(', ');
              final assignedDays = chore.days.map((day) => ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][day]).join(', ');

              return ListTile(
                title: Text(chore.name),
                subtitle: Text('Assigned to: ${assignedProfiles ?? 'N/A'}\nDays: $assignedDays'),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Task: ${chore.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('Description: ${chore.description}'),
                            SizedBox(height: 8),
                            Text('Assigned to: ${assignedProfiles ?? 'N/A'}'),
                            SizedBox(height: 8),
                            Text('Days: $assignedDays'),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
