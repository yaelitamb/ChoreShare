import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database.dart'; // Asegúrate de tener el archivo de la base de datos importado
import 'screens/create_household.dart';
import 'screens/join_household.dart';
import 'screens/household_screen.dart';
import 'screens/chores_screen.dart';
import 'screens/done_screen.dart';
import 'audio_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChoreShareDatabase.instance),
        Provider(create: (_) => AudioService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    audioService.playBackgroundMusic(); // Inicia la música de fondo

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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChoreShare'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Aquí puedes continuar con tu diseño y funcionalidad según lo necesites
          ],
        ),
      ),
    );
  }
}
