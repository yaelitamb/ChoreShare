import 'package:flutter/material.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Tasks'),
      ),
      body: ListView.builder(
        itemCount: 10, // Este es solo un ejemplo, debes ajustarlo según tus necesidades
        itemBuilder: (context, index) {
          // Aquí debes construir cada elemento de la lista de tareas realizadas
          return ListTile(
            title: Text('Task ${index + 1}'),
            // Agrega aquí cualquier otra información que quieras mostrar
          );
        },
      ),
    );
  }
}
