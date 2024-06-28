import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notes_provider.dart';

class TextNotePage extends ConsumerStatefulWidget {
  final String noteId;

  TextNotePage({required this.noteId});

  @override
  _TextNotePageState createState() => _TextNotePageState();
}

class _TextNotePageState extends ConsumerState<TextNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    final note = ref.read(notesProvider.notifier).state.firstWhere((note) => note.id == widget.noteId);
    _titleController = TextEditingController(text: note.title);
    _contentController = TextEditingController(text: note.textContent);
  }

  void _saveNote() {
    final updatedNote = ref.read(notesProvider.notifier).state.firstWhere((note) => note.id == widget.noteId).copyWith(
      title: _titleController.text,
      textContent: _contentController.text,
    );
    ref.read(notesProvider.notifier).updateNote(updatedNote);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.deepOrange),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
              ),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Colors.deepOrange),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreenAccent),
                  ),
                ),
                maxLines: null,
                expands: true,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
