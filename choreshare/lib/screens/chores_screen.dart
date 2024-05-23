import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/chore.dart';

class ChoresScreen extends StatefulWidget {
  @override
  _ChoresScreenState createState() => _ChoresScreenState();
}

class _ChoresScreenState extends State<ChoresScreen> {
  List<Chore> _chores = [];

  @override
  void initState() {
    super.initState();
    _loadChores();
  }

  Future<void> _loadChores() async {
    final chores = await Provider.of<ChoreShareDatabase>(context, listen: false).getChores();
    setState(() {
      _chores = chores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chores'),
      ),
      body: ListView.builder(
        itemCount: _chores.length,
        itemBuilder: (context, index) {
          final chore = _chores[index];
          return ListTile(
            title: Text(chore.name),
            subtitle: Text('Every ${chore.repetition}'),
            trailing: Icon(Icons.check_box_outline_blank),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add chore screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
