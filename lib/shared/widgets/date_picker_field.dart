import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final String label;

  final DateTime? selectedDate;

  final ValueChanged<DateTime> onSelected;

  final DateTime? firstDate;

  final DateTime? lastDate;

  final IconData? icon;
  final bool enabled;
  final String? Function(DateTime?)? validator;

  const DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onSelected,
    this.firstDate,
    this.lastDate,
    this.icon,
    this.enabled = true,
    this.validator,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2100),
    );

    if (picked != null) {
      onSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _pickDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon ?? Icons.calendar_today),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          selectedDate == null
              ? 'Select Date'
              : DateFormat('dd MMM yyyy').format(selectedDate!),
          style: TextStyle(color: selectedDate == null ? Colors.grey : null),
        ),
      ),
    );
  }
}
