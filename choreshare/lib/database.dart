import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/profile.dart';
import 'models/chore.dart';

class ChoreShareDatabase with ChangeNotifier {
  static final ChoreShareDatabase instance = ChoreShareDatabase._init();
  static Database? _database;

  ChoreShareDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('chore_share.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const profileTable = '''
    CREATE TABLE profiles (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      color TEXT,
      photo TEXT
    );
    ''';

    const choreTable = '''
    CREATE TABLE chores (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      description TEXT,
      assignedProfiles TEXT,
      rotation INTEGER,
      repetition TEXT,
      every TEXT,
      days TEXT
    );
    ''';

    await db.execute(profileTable);
    await db.execute(choreTable);
  }

  Future<int> insertProfile(Profile profile) async {
    final db = await instance.database;
    return await db.insert('profiles', profile.toMap());
  }

  Future<List<Profile>> getProfiles() async {
    final db = await instance.database;
    final result = await db.query('profiles');
    return result.map((json) => Profile.fromMap(json)).toList();
  }

  Future<Profile> getProfile(int id) async {
    final db = await instance.database;
    final result = await db.query('profiles', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Profile.fromMap(result.first);
    } else {
      throw Exception('Profile with id $id not found');
    }
  }

  Future<int> deleteProfile(int id) async {
    final db = await instance.database;
    return await db.delete('profiles', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertChore(Chore chore) async {
    final db = await instance.database;
    final id = await db.insert('chores', chore.toMap());
    notifyListeners(); // Notifica a los oyentes después de insertar una tarea
    return id;
  }

  Future<List<Chore>> getChores() async {
    final db = await instance.database;
    final result = await db.query('chores');
    return result.map((json) => Chore.fromMap(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
