import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import 'package:uuid/uuid.dart';
import 'graph_page.dart';
import 'text_note_page.dart';

class NotesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: notes.isEmpty
            ? Center(
          child: Text(
            'No notes available.',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  note.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  note.type == NoteType.text ? note.textContent ?? '' : 'Graph Note',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ref.read(notesProvider.notifier).deleteNote(note.id);
                  },
                ),
                onTap: () {
                  if (note.type == NoteType.text) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TextNotePage(noteId: note.id),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GraphPage(noteId: note.id),
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog(context, ref);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    NoteType? noteType = NoteType.text;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                if (noteType == NoteType.text)
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(labelText: 'Content'),
                  ),
                DropdownButton<NoteType>(
                  value: noteType,
                  onChanged: (NoteType? newValue) {
                    noteType = newValue;
                    (context as Element).reassemble(); // Trigger rebuild to show/hide content TextField
                  },
                  items: [
                    DropdownMenuItem(value: NoteType.text, child: Text('Text Note')),
                    DropdownMenuItem(value: NoteType.graph, child: Text('Graph Note')),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final note = Note(
                  id: Uuid().v4(),
                  title: titleController.text,
                  textContent: noteType == NoteType.text ? contentController.text : null,
                  dataPoints: noteType == NoteType.graph ? [] : null,
                  type: noteType!,
                );
                if (note.type == NoteType.text) {
                  ref.read(notesProvider.notifier).addTextNote(
                    title: note.title,
                    textContent: note.textContent!,
                  );
                } else {
                  ref.read(notesProvider.notifier).addGraphNote(
                    title: note.title,
                    dataPoints: [],
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Add',  style: TextStyle(color: Colors.deepOrange)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.deepOrange),
            ),),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(BuildContext context, WidgetRef ref, Note note, int index) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.textContent);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                if (note.type == NoteType.text)
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(labelText: 'Content'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedNote = note.copyWith(
                  title: titleController.text,
                  textContent: note.type == NoteType.text ? contentController.text : null,
                );
                ref.read(notesProvider.notifier).updateNote(updatedNote);
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.deepOrange),
            ),),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.deepOrange),
              )
            ),
          ],
        );
      },
    );
  }
}
