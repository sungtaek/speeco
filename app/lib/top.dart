
import 'package:flutter/material.dart';

class SpeecoTop extends StatelessWidget implements PreferredSizeWidget {

  const SpeecoTop({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('speeco'),
      centerTitle: true,
      leading: const IconButton(icon: Icon(Icons.menu), onPressed: null),
    );
  }

}