import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/note.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]) {
    _loadNotes();
  }

  final Box<Note> _notesBox = Hive.box<Note>('notesBox');

  Future<void> _loadNotes() async {
    state = _notesBox.values.toList();
  }

  Future<void> addTextNote({
    required String title,
    required String textContent,
  }) async {
    final newNote = Note(
      id: Uuid().v4(),
      title: title,
      textContent: textContent,
      type: NoteType.text,
    );
    state = [...state, newNote];
    await _notesBox.put(newNote.id, newNote);
  }

  Future<void> addGraphNote({
    required String title,
    required List<FlSpot> dataPoints,
  }) async {
    final newNote = Note(
      id: Uuid().v4(),
      title: title,
      dataPoints: Note.convertFlSpotList(dataPoints),
      type: NoteType.graph,
    );
    state = [...state, newNote];
    await _notesBox.put(newNote.id, newNote);
  }

  Future<void> updateNote(Note updatedNote) async {
    state = [
      for (final note in state)
        if (note.id == updatedNote.id) updatedNote else note,
    ];
    await _notesBox.put(updatedNote.id, updatedNote);
  }

  Future<void> deleteNote(String id) async {
    state = state.where((note) => note.id != id).toList();
    await _notesBox.delete(id);
  }
}
