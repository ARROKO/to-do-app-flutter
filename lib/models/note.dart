import 'package:isar/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Id? id = Isar.autoIncrement; // you can also use id = null to auto increment
  
  late String text;
  DateTime? creationDate;
  Note({required this.text, this.creationDate, this.id}) {
    creationDate = DateTime.now();
  }
}
