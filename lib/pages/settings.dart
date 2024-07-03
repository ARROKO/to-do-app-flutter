import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool theme = ThemeProvider().isDarkMode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
      //   actions: [
      //   IconButton(
      //     onPressed: () {
      //       setState(() {
      //         Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      //         theme = !theme;
      //       });
      //     },
      //     icon: !theme
      //         ? const Icon(CupertinoIcons.moon_fill)
      //         : const Icon(CupertinoIcons.sun_max),
      //   ),
      // ]
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Color theme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                onPressed: () {
                  setState(() {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .greyModeTheme();
                  });
                },
                child: Text(
                  'Grey',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .lightTheme();
                  });
                },
                child: Text(
                  'Light',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .darkTheme();
                  });
                },
                child: Text(
                  'Dark',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
