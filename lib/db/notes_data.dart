import 'package:mikebatabase/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase.init();
  static Database? _database;
  NotesDatabase.init();

 Future<Database> _initDB(String filePAth) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePAth);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

 

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = "TEXT NOT NULL";
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = "INTEGER NOT NULL";
    await db.execute('''CREATE TABLE $tableNotes (
          ${NoteFields.id} $idType, 
          ${NoteFields.isImportant} $boolType,
          ${NoteFields.number} $integerType,
          ${NoteFields.title} $textType,
          ${NoteFields.description} $textType,
          ${NoteFields.time} $textType
          )''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final json = note.toJson();

   final id = await db.insert(tableNotes, json);
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableNotes,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception("id $id not found");
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db
        .delete(tableNotes, where: '${NoteFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
