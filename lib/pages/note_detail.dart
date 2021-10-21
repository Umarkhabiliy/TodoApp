import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mikebatabase/db/notes_data.dart';
import 'package:mikebatabase/models/note.dart';
import 'package:mikebatabase/pages/note_edit.dart';

class NoteDetail extends StatefulWidget {
  final int noteId;

  const NoteDetail({Key? key, required this.noteId}) : super(key: key);

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late Note note;
  bool isLoading = false;
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    this.note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: TextStyle(color: Colors.white38),
                  ),
                  SizedBox(height: 8),
                  Text(
                    note.description,
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  )
                ],
              ),
            ),
    );
  }

  Widget editButton() => IconButton(
     icon: Icon(Icons.edit_outlined),
        onPressed: () async {
          if (isLoading) return;
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteEdit(
                    note: note,
                  )));
          refreshNote();
        },
     
      );
  Widget deleteButton() => IconButton(
      onPressed: () async {
        await NotesDatabase.instance.delete(widget.noteId);
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.delete));
}
