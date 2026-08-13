import 'dart:async';

import 'package:flutter/material.dart';

class SearchDropdownField<T> extends StatefulWidget {
  final String label;

  final Future<List<T>> Function(String query) onSearch;

  final String Function(T item) displayText;

  final void Function(T item) onSelected;
  final VoidCallback? onCleared;
  final String? initialText;
  final String? errorText;
  final bool required;

  const SearchDropdownField({
    super.key,
    required this.label,
    required this.onSearch,
    required this.displayText,
    required this.onSelected,
    this.onCleared,
    this.initialText,
    this.errorText,
    this.required = false,
  });

  @override
  State<SearchDropdownField<T>> createState() => _SearchDropdownFieldState<T>();
}

class _SearchDropdownFieldState<T> extends State<SearchDropdownField<T>> {
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;

  List<T> _items = [];

  bool _loading = false;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText ?? '';
  }

  Future<void> _search(String query) async {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isEmpty) {
        widget.onCleared?.call();

        setState(() {
          _items = [];
          _searchError = null;
        });

        return;
      }

      setState(() {
        _loading = true;
      });

      try {
        final results = await widget.onSearch(query);

        if (!mounted) return;

        setState(() {
          _items = results;
          _searchError = null;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _items = [];
          _searchError = 'Could not load options. Type to retry.';
        });
      } finally {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: _search,
          decoration: InputDecoration(
            labelText: widget.required ? '${widget.label} *' : widget.label,
            errorText: widget.errorText ?? _searchError,
            border: const OutlineInputBorder(),

            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search),
          ),
        ),

        if (_items.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _items[index];

                return ListTile(
                  dense: true,
                  title: Text(widget.displayText(item)),
                  onTap: () {
                    _controller.text = widget.displayText(item);

                    widget.onSelected(item);

                    setState(() {
                      _items = [];
                    });

                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
