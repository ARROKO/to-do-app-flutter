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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
                  ThemeApp(
                    color:const Color(0xFFF1E5D1),
                    onTap: () {
                      setState(() {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .greyModeTheme();
                      });
                    },
                  ),
                  ThemeApp(
                    color: Colors.grey.shade300,
                    onTap: () {
                      setState(() {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .lightTheme();
                      });
                    },
                  ),
                  ThemeApp(
                    color: const Color(0xFF1F1D2B),
                    onTap: () {
                      setState(() {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .darkTheme();
                      });
                    },
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

class ThemeApp extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  const ThemeApp({
    super.key,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
