import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/note_database.dart';
import '../models/note.dart';
import '../widgets/drawer.dart';
import 'edit_note.dart';

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
  void updateNote(Note note, BuildContext context) {
    textController.text = note.text;
    Navigator.push(context, MaterialPageRoute(builder: (context) => Edit(note: note)));
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
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const MyDawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: Icon(Icons.add,color: Theme.of(context).colorScheme.inversePrimary,),
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
                    return Card(
                      child: ListTile(
                        title: Text(note.text),
                        trailing: Builder(builder: (context) {
                          return IconButton(
                            onPressed: () {
                              showPopover(
                                context: context,
                                bodyBuilder: (context) => ListItems(
                                  edit: () => updateNote(note, context),
                                  delete: () => deleteNote(note.id),
                                ),
                                onPop: () => print('Popover was popped!'),
                                direction: PopoverDirection.bottom,
                                width: 100,
                                height: 100,
                                arrowHeight: 15,
                                arrowWidth: 30,
                              );
                            },
                            icon: const Icon(Icons.more_vert),);
                        }),
                        // trailing: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     IconButton(
                        //       onPressed: () => updateNote(note),
                        //       icon: const Icon(Icons.edit),
                        //     ),
                            
                        //   ],
                        // ),
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
  final VoidCallback edit;
  final VoidCallback delete;
  const ListItems({super.key, required this.edit, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(onPressed: (){
          Navigator.pop(context);
          edit();
          }, child: Text('Edit',style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),)),
        TextButton(onPressed: (){
          Navigator.pop(context);
          delete();
          }, child: Text('Delete',style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),)),
      ],
    );
  }
}
