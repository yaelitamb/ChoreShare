import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../database.dart';
import '../models/profile.dart';

class AddProfileScreen extends StatefulWidget {
  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _nameController = TextEditingController();
  String _selectedColor = 'Red';
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<int> _generateUniqueId(ChoreShareDatabase db) async {
    final random = Random();
    int id;
    List<int> existingIds = (await db.getProfiles()).map((profile) => profile.id).toList();

    do {
      id = random.nextInt(1000000); // Genera un ID aleatorio entre 0 y 999999
    } while (existingIds.contains(id));

    return id;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showAddProfileDialog(BuildContext context, ChoreShareDatabase db) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                DropdownButton<String>(
                  value: _selectedColor,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedColor = newValue!;
                    });
                  },
                  items: <String>['Red', 'Green', 'Blue', 'Yellow']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
                _image != null
                    ? Image.file(_image!)
                    : Text('No image selected.'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty && _selectedColor.isNotEmpty && _image != null) {
                  int id = await _generateUniqueId(db);
                  final profile = Profile(
                    id: id,
                    name: _nameController.text,
                    color: _selectedColor,
                    photo: _image!.path,
                  );

                  await db.insertProfile(profile);

                  setState(() {
                    _nameController.clear();
                    _selectedColor = 'Red';
                    _image = null;
                  });

                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<ChoreShareDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Profiles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _showAddProfileDialog(context, db),
              child: Text('Add Profile'),
            ),
            Expanded(
              child: FutureBuilder<List<Profile>>(
                future: db.getProfiles(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final profiles = snapshot.data!;

                  return ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      return ListTile(
                        leading: Image.file(File(profile.photo)),
                        title: Text(profile.name),
                        subtitle: Text(profile.color),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await db.deleteProfile(profile.id);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para continuar a la siguiente pantalla, si es necesario
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
