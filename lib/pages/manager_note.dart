import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../models/note.dart';
import '../models/note_database.dart';

class ManagerNote extends StatefulWidget {
  final Note? note;
  const ManagerNote({super.key, this.note});

  @override
  State<ManagerNote> createState() => _ManagerNoteState();
}

class _ManagerNoteState extends State<ManagerNote>
    with SingleTickerProviderStateMixin {
  QuillController controller = QuillController.basic();
  bool isEmpty = true;
  bool isExistingNote = false;
  bool isModified = false;
  String _editorText = '';

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      controller = QuillController(
        document: Document.fromHtml(widget.note!.text),
        selection: const TextSelection.collapsed(offset: 0),
      );
      isExistingNote = true;
      isEmpty = false;
    }
    controller.addListener(_updateEditorText);
  }
  
  void _updateEditorText() {
    setState(() {
      _editorText = controller.document.toPlainText().trim();
    });
  }

  @override
  void dispose() {
    controller.removeListener(_updateEditorText);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          !isEmpty ? // Afficher l'icône seulement si le TextField n'est pas vide
            IconButton(
              onPressed: () {
                if (isExistingNote && isModified) {
                  // Mettre à jour la note existante
                  context.read<NoteDatabase>().updateNotes(widget.note!.id,
                      controller.document.toPlainText(), DateTime.now());
                } else if (!isExistingNote) {
                  // Ajouter une nouvelle note
                  context
                      .read<NoteDatabase>()
                      .addNote(controller.document.toPlainText());
                }
                if (isExistingNote) {
                  Navigator.pop(
                      context); // Retourner à l'écran précédent après mise à jour ou suppression
                } else {
                  setState(() {
                    isExistingNote = true; // La note est maintenant existante
                    isModified = false;
                  });
                }
              },
              icon: Icon(
                  isExistingNote && !isModified ? Icons.delete : Icons.check),
            )
            :
            (_editorText.isNotEmpty ?
              IconButton(onPressed: (){
                context
                      .read<NoteDatabase>()
                      .addNote(controller.document.toPlainText());
              }, icon: const Icon(Icons.check)) : const Text(''))
        ],
      ),
      body: Column(
        children: [
          widget.note != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat('dd-MM-yyyy HH:mm').format(
                      DateTime.parse(widget.note!.creationDate.toString()))),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())),
                ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  color: Theme.of(context).colorScheme.primary,
                  sectionDividerColor: Colors.red,
                  showFontFamily: false,
                  showAlignmentButtons: false,
                  showCenterAlignment: false,
                  showClearFormat: false,
                  showClipboardCopy: false,
                  showClipboardPaste: false,
                  showCodeBlock: false,
                  showClipboardCut: false,
                  showDirection: false,
                  showDividers: false,
                  showHeaderStyle: false,
                  showIndent: false,
                  showFontSize: false,
                  showInlineCode: false,
                  showJustifyAlignment: false,
                  showLink: true,
                  showRightAlignment: false,
                  showUndo: false,
                  showSearchButton: false,
                  showListNumbers: false,
                  showBackgroundColorButton: false,
                  showListCheck: false,
                  showRedo: false,
                  showQuote: false,
                  showSubscript: false,
                  showSuperscript: false,
                  controller: controller,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('de'),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: controller,
                  
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('de'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
