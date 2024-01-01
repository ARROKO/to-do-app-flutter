import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/note_database.dart';
import '../models/note.dart';

class NotePages extends StatefulWidget {
  const NotePages({super.key});

  @override
  State<NotePages> createState() => _NotePagesState();
}

class _NotePagesState extends State<NotePages> {
  //tet controller to access what the user typed
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  // create a note
  void createNote() {
    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  // add to db
                  context.read<NoteDatabase>().addNote(textController.text);
                  Navigator.pop(context);
                },
                child: const Text("Create"),
              ),
            ],
          )),
    );
  }

  // read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // update a notes
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Note'),
            content: TextField(controller: textController),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // add to db
                  context
                      .read<NoteDatabase>()
                      .updateNotes(note.id, textController.text);
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          );
        });
  }

  // delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNotes(id);
  }

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();

    // current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      drawer: const Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Text('Notes',style: Goo,),
          Expanded(
            child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  final note = currentNotes[index];
                  return ListTile(
                    title: Text(note.text),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => updateNote(note),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => deleteNote(note.id),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.deepPurple[300],
          height: 50,
        ),
        Container(
          color: Colors.deepPurple[200],
          height: 50,
        ),
        Container(
          color: Colors.deepPurple[100],
          height: 50,
        ),
      ],
    );
  }
}
