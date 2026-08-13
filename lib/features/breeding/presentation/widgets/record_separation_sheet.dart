import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/models/record_separation_request.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/bloc/breeding_bloc.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/bloc/breeding_event.dart';

class RecordSeparationSheet extends StatefulWidget {
  final String breedingId;

  const RecordSeparationSheet({super.key, required this.breedingId});

  @override
  State<RecordSeparationSheet> createState() => _RecordSeparationSheetState();
}

class _RecordSeparationSheetState extends State<RecordSeparationSheet> {
  final _formKey = GlobalKey<FormState>();

  DateTime _separationDate = DateTime.now();

  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Record Separation",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),

                const SizedBox(height: 24),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text("Separation Date"),
                  subtitle: Text(
                    DateFormat('dd MMM yyyy').format(_separationDate),
                  ),
                  trailing: const Icon(Icons.edit_calendar),
                  onTap: _pickDate,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Notes (Optional)",
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: const Text("COMPLETE"),
                    onPressed: _save,
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _separationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (result != null) {
      setState(() {
        _separationDate = result;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<BreedingBloc>().add(
      RecordSeparation(
        widget.breedingId,
        RecordSeparationRequest(
          separationDate: DateUtils.dateOnly(_separationDate),
        ),
      ),
    );

    Navigator.pop(context);
  }
}
