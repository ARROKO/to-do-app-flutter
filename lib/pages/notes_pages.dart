import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/note_database.dart';
import '../models/note.dart';
import '../widgets/drawer.dart';
import 'manager_note.dart';

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
                  context.read<NoteDatabase>().updateNotes(
                      note.id, textController.text, DateTime.now());
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const MyDawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ManagerNote()));
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  itemCount: currentNotes.length,
                  itemBuilder: (context, index) {
                    final note = currentNotes[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManagerNote(note: note)));
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        child: ListTile(
                          title: Text(
                            note.text,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          trailing: Builder(builder: (context) {
                            return IconButton(
                              onPressed: () {
                                showPopover(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  context: context,
                                  bodyBuilder: (context) => ListItems(
                                    note: note,
                                    edit: () => updateNote(note),
                                    delete: () => deleteNote(note.id),
                                  ),
                                  direction: PopoverDirection.bottom,
                                  width: 100,
                                  height: 100,
                                  arrowHeight: 15,
                                  arrowWidth: 30,
                                );
                              },
                              icon: Icon(
                                Icons.more_vert,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  final Note note;
  final VoidCallback edit;
  final VoidCallback delete;
  const ListItems(
      {super.key,
      required this.edit,
      required this.delete,
      required this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              Clipboard.setData(ClipboardData(text: note.text));
              Fluttertoast.showToast(
                msg: "Texte copié",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 16.0,
              );
            },
            child: Text(
              'Copy',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            )),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              delete();
            },
            child: Text(
              'Delete',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            )),
      ],
    );
  }
}
