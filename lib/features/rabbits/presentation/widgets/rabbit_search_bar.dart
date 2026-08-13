import 'package:flutter/material.dart';

class RabbitSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RabbitSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search rabbits',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: onChanged,
    );
  }
}
