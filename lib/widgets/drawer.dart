import 'package:flutter/material.dart';

import 'drawer_tile.dart';

class MyDawer extends StatelessWidget {
  const MyDawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            // drawer header
            const DrawerHeader(
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),

            // drawer tile
            DrawerTile(
              title: 'Notes',
              leading: const Icon(Icons.home),
              onTap: () => Navigator.pop(context),
            ),

            // drawer settings
            DrawerTile(
              title: 'Settings',
              leading: const Icon(Icons.settings),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ));
  }
}
