import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database.dart';
import 'screens/create_household.dart';
import 'screens/join_household.dart';
import 'screens/household_screen.dart';
import 'screens/chores_screen.dart';
import 'screens/done_screen.dart';
import 'audio_provider.dart'; // Importa el proveedor de audio

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ChoreShareDatabase>(
          create: (_) => ChoreShareDatabase.instance,
        ),
        ChangeNotifierProvider<AudioProvider>(
          create: (_) => AudioProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChoreShare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChoreShare'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png'), // Asegúrate de usar el nombre correcto de tu imagen
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await audioProvider.startPlaying(); // Inicia la reproducción del audio
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateHouseholdScreen()),
                );
              },
              child: const Text('Create New Household'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JoinHouseholdScreen()),
                );
              },
              child: const Text('Join Existing Household'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HouseholdScreen(),
    const ChoresScreen(),
    const DoneScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChoreShare'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Household',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Chores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Done',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
