import 'package:flutter/material.dart';
import 'package:note/models/note.dart';
import 'package:intl/intl.dart';

class Edit extends StatefulWidget {
  final Note note;
  const Edit({super.key, required this.note});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.check),),
        ],
      ),
      body: Column(
        children: [
          // Text(DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(widget.note.dateTime.toString()))),
          Text(widget.note.text),
        ],
      ),
    );
  }
}