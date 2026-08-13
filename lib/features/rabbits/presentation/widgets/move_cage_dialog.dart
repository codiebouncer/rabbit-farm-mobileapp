import 'package:flutter/material.dart';

class MoveCageDialog extends StatefulWidget {
  const MoveCageDialog({super.key});

  @override
  State<MoveCageDialog> createState() => _MoveCageDialogState();
}

class _MoveCageDialogState extends State<MoveCageDialog> {
  final cageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Move Rabbit'),

      content: TextField(
        controller: cageController,
        decoration: const InputDecoration(labelText: 'New Cage ID'),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),

        FilledButton(
          onPressed: () {
            Navigator.pop(context, cageController.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
