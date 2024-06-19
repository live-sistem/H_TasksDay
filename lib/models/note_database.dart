import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:h_tasksday/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;
  // INIT DB
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  // list of notes
  final List<Note> currentNotes = [];

  // CREATE IN DB
  Future<void> addNote(String textFromUser) async {
    //create a new note object
    if (textFromUser != "") {
      final pancakes = Note()
        ..text = textFromUser
        ..createdTime = DateTime.now();
      // ignore: unused_local_variable
      await isar.writeTxn(() => isar.notes.put(pancakes));
      fetchNotes();
    }

    //re-raed form db
  }

  // READ IN DB
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();

    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  // UPDATE IN DB
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      if (existingNote.text != newText) {
        existingNote.text = newText;
        existingNote.createdTime = DateTime.now();
        await isar.writeTxn(() => isar.notes.put(existingNote));
        await fetchNotes();
      }
    }
  }

  // DELETE IN DB
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
