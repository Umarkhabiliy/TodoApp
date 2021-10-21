import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mikebatabase/db/notes_data.dart';
import 'package:mikebatabase/models/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mikebatabase/pages/note_detail.dart';
import 'package:mikebatabase/pages/note_edit.dart';
import 'package:mikebatabase/widgete/cardWidget.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Notes",
            style: TextStyle(fontSize: 24),
          ),
          actions: [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? CupertinoActivityIndicator()
              : notes.isEmpty
                  ? Text(
                      'No Notes',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF878683),
          child: Icon(Icons.add,color: Color(0xFF444444),),
          onPressed: () async {
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NoteEdit()));
            refreshNotes();
          },
        ),
      );
  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
               await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetail(noteId: note.id!)));
              refreshNotes();
            },
            child: CardWidget(
              note: note,
              index: index,
            ),
          );
        },
      );
}
