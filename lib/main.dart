import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/notes_pages.dart';
import 'models/note_database.dart';
import 'pages/settings.dart';
import 'theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // initialize note isae database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
      create: (context) => NoteDatabase(),
    ),
      ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
    ],
    child: ChangeNotifierProvider(
    create: (context) => ThemeProvider(isDarkMode: prefs.getBool('isDarkMode')),
    child: const MyApp(),
  ),
    ), 
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const NotePages(),
      routes: {
        '/settings': (context)=> const Settings(),
      },
    );
  }
}
