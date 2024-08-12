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
  // State to track selected notes
  final Set<int> selectedNotes = {};

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
                      note.id!, textController.text, DateTime.now());
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

  // delete multiple notes
  void deleteSelectedNotes() {
    for (var id in selectedNotes) {
      context.read<NoteDatabase>().deleteNotes(id);
    }
    setState(() {
      selectedNotes.clear();
    });
  }

  // cancel multiple selection
  void cancelSelection() {
    setState(() {
      selectedNotes.clear();
    });
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
        // leading: selectedNotes.isNotEmpty ? IconButton(
        //   icon: const Icon(Icons.cancel),
        //   onPressed: cancelSelection,
        // ) : const SizedBox(),
        elevation: 0,
        actions: selectedNotes.isNotEmpty
            ? [
                
                selectedNotes.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: cancelSelection,
                      )
                    : const SizedBox(),
              ]
            : null,
      ),
      drawer: selectedNotes.isEmpty
          ? const MyDawer()
          : null, // Conditionally show the drawer
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          selectedNotes.isEmpty ?
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ManagerNote())) :
              deleteSelectedNotes();
        },
        child: Icon(
          selectedNotes.isEmpty ? Icons.add : Icons.delete,
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
                    bool isSelected = selectedNotes.contains(note.id);
                    return GestureDetector(
                      onTap: () {
                        if (selectedNotes.isNotEmpty) {
                          setState(() {
                            if (isSelected) {
                              selectedNotes.remove(note.id);
                            } else {
                              selectedNotes.add(note.id!);
                            }
                          });
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ManagerNote(note: note)));
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          selectedNotes.add(note.id!);
                        });
                      },
                      child: Card(
                        color: isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
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
                          trailing: selectedNotes.isEmpty
                              ? Builder(builder: (context) {
                                  return IconButton(
                                    onPressed: () {
                                      showPopover(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        context: context,
                                        bodyBuilder: (context) => ListItems(
                                          note: note,
                                          edit: () => updateNote(note),
                                          delete: () => deleteNote(note.id!),
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
                                })
                              : Checkbox(
                                checkColor: Theme.of(context).colorScheme.inversePrimary,
                                value: isSelected, onChanged: (value){
                                setState(() {
                                  isSelected = value!;
                                });
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
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            delete();
          },
          child: Text(
            'Delete',
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
      ],
    );
  }
}
