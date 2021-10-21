import 'package:flutter/material.dart';
import 'package:mikebatabase/db/notes_data.dart';
import 'package:mikebatabase/models/note.dart';
import 'package:mikebatabase/widgete/formWidget.dart';

class NoteEdit extends StatefulWidget {
  final Note? note;
  const NoteEdit({Key? key, this.note}) : super(key: key);

  @override
  _NoteEditState createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          isImportant: isImportant,
          number: number,
          title: title,
          description: description,
          // onChangedImportant: (isImportant) =>
              // setState(() => this.isImportant = isImportant),
          // onChangedNumber: (number) => setState(() => this.number = number),
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedDescription: (description) =>
              setState(() => this.description = description),
        ),
      ),
    );
  }

  Widget buildButton() {
    final isFromValid = title.isNotEmpty && description.isNotEmpty;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: isFromValid ? null : Colors.grey.shade700),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await updateNote();
      } else {
        addNotes();
      }
      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description);
    await NotesDatabase.instance.update(note);
  }

  Future addNotes() async {
    final note = Note(
        isImportant: true,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());
    await NotesDatabase.instance.create(note);
  }
}
