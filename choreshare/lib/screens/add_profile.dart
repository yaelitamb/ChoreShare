import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/profile.dart';

class AddProfileScreen extends StatefulWidget {
  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _nameController = TextEditingController();
  String? _selectedColor;
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            DropdownButton<String>(
              value: _selectedColor,
              hint: Text('Select a color'),
              items: ['Red', 'Blue', 'Green', 'Yellow'].map((color) {
                return DropdownMenuItem(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedColor = value;
                });
              },
            ),
            _imageFile == null
                ? TextButton(
                    onPressed: _pickImage,
                    child: Text('Select Photo'),
                  )
                : Image.file(_imageFile!),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty && _selectedColor != null && _imageFile != null) {
                  final profile = Profile(
                    id: 0,
                    name: _nameController.text,
                    color: _selectedColor!,
                    photo: _imageFile!.path,
                  );
                  await Provider.of<ChoreShareDatabase>(context, listen: false).insertProfile(profile);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
