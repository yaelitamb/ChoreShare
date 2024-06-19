import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'models/chore.dart';
import 'models/profile.dart';

class ChoreShareDatabase extends ChangeNotifier {
  static const String _dbName = 'choreshare.db';
  static const int _dbVersion = 1;

  ChoreShareDatabase._privateConstructor();
  static final ChoreShareDatabase instance = ChoreShareDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profiles(
        id INTEGER PRIMARY KEY,
        name TEXT,
        color TEXT,
        photo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE chores(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        assignedProfiles TEXT,
        rotation INTEGER,
        repetition TEXT,
        every TEXT,
        days TEXT
      )
    ''');
  }

  Future<List<Profile>> getProfiles() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profiles');
    return List.generate(maps.length, (index) {
      return Profile.fromMap(maps[index]);
    });
  }

  Future<int> insertProfile(Profile profile) async {
    final Database db = await database;
    final result = await db.insert('profiles', profile.toMap());
    notifyListeners();
    return result;
  }

  Future<int> deleteProfile(int id) async {
    final Database db = await database;
    final result = await db.delete('profiles', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
    return result;
  }

  Future<List<Chore>> getChores() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chores');
    final profiles = await getProfiles();
    return List.generate(maps.length, (index) {
      return Chore.fromMap(maps[index], profiles);
    });
  }

  Future<int> insertChore(Chore chore) async {
    final Database db = await database;
    final result = await db.insert('chores', chore.toMap());
    notifyListeners();
    return result;
  }

  Future<int> updateChore(Chore chore) async {
    final Database db = await database;
    final result = await db.update('chores', chore.toMap(), where: 'id = ?', whereArgs: [chore.id]);
    notifyListeners();
    return result;
  }
}
