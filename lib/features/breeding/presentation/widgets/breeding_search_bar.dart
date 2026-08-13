import 'dart:async';

import 'package:flutter/material.dart';

class BreedingSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const BreedingSearchBar({super.key, required this.onChanged});

  @override
  State<BreedingSearchBar> createState() => _BreedingSearchBarState();
}

class _BreedingSearchBarState extends State<BreedingSearchBar> {
  final _controller = TextEditingController();

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onSearch,
      decoration: InputDecoration(
        hintText: 'Search Doe or Buck Rabbit ID...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();

                  widget.onChanged('');
                  setState(() {});
                },
              )
            : null,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
