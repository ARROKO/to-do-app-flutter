import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../models/note_database.dart';

class ManagerNote extends StatefulWidget {
  Note? note;
  ManagerNote({super.key, this.note});

  @override
  State<ManagerNote> createState() => _ManagerNoteState();
}

class _ManagerNoteState extends State<ManagerNote> {
  TextEditingController controller = TextEditingController();
  FocusNode textFocusNode = FocusNode(); // Création d'un FocusNode
  bool isEmpty = true;
  bool isExistingNote = false;
  bool isModified = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      controller.text = widget.note!.text;
      isEmpty = controller.text.isEmpty;
      isExistingNote = true;
    } else {
      textFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (!isEmpty)
            IconButton(
              icon: Icon(isExistingNote
                  ? (isModified ? Icons.check : Icons.delete)
                  : Icons.check),
              onPressed: () async {
                if (isExistingNote && !isModified) {
                  // Delete the note
                  context.read<NoteDatabase>().deleteNotes(widget.note!.id!);
                  Navigator.of(context).pop();
                } else {
                  // Add or update the note
                  if (isExistingNote) {
                    context.read<NoteDatabase>().updateNotes(
                        widget.note!.id!, controller.text, DateTime.now());
                    setState(() {
                      isModified =
                          false; // Reset modification status after update
                    });
                  } else {
                    int newId = await context
                        .read<NoteDatabase>()
                        .addNote(controller.text);
                    setState(() {
                      widget.note = Note(
                          id: newId,
                          text: controller.text,
                          creationDate: DateTime.now());

                      isExistingNote = true; // La note est maintenant existante
                      isModified =
                          false; // La note vient d'être créée, pas modifiée
                    });
                  }
                }
                textFocusNode.unfocus(); // Retire le focus et ferme le clavier
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateFormat('dd-MM-yyyy HH:mm').format(widget.note != null
                  ? DateTime.parse(widget.note!.creationDate.toString())
                  : DateTime.now()),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: textFocusNode, // Utilisation du FocusNode
                controller: controller,
                expands: true,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Enter your note',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    isEmpty = value.isEmpty;
                    isModified = true; // Set as modified whenever text changes
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
