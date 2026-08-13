import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/models/record_birth_request.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/bloc/breeding_bloc.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/bloc/breeding_event.dart';

class RecordBirthSheet extends StatefulWidget {
  final String breedingId;

  const RecordBirthSheet({super.key, required this.breedingId});

  @override
  State<RecordBirthSheet> createState() => _RecordBirthSheetState();
}

class _RecordBirthSheetState extends State<RecordBirthSheet> {
  final _formKey = GlobalKey<FormState>();

  final _kitsController = TextEditingController();
  final _aliveController = TextEditingController();
  final _maleController = TextEditingController();
  final _femaleController = TextEditingController();

  DateTime _birthDate = DateTime.now();

  int get kits => int.tryParse(_kitsController.text) ?? 0;

  int get alive => int.tryParse(_aliveController.text) ?? 0;

  int get male => int.tryParse(_maleController.text) ?? 0;

  int get female => int.tryParse(_femaleController.text) ?? 0;

  int get deaths => (kits - alive).clamp(0, 999);

  @override
  void dispose() {
    _kitsController.dispose();
    _aliveController.dispose();
    _maleController.dispose();
    _femaleController.dispose();
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
              children: [
                Text(
                  "Record Birth",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 24),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Birth Date"),
                  subtitle: Text(
                    "${_birthDate.day}/${_birthDate.month}/${_birthDate.year}",
                  ),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: _pickDate,
                ),

                const SizedBox(height: 16),

                _numberField(controller: _kitsController, label: "Kits Born"),

                const SizedBox(height: 12),

                _numberField(controller: _aliveController, label: "Alive"),

                const SizedBox(height: 12),

                _numberField(controller: _maleController, label: "Male Kits"),

                const SizedBox(height: 12),

                _numberField(
                  controller: _femaleController,
                  label: "Female Kits",
                ),

                const SizedBox(height: 24),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text("Deaths"),
                    trailing: Text(
                      deaths.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text("SAVE"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (_) => setState(() {}),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required";
        }
        return null;
      },
      decoration: InputDecoration(labelText: label),
    );
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (result != null) {
      setState(() {
        _birthDate = result;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<BreedingBloc>().add(
      RecordBirth(
        widget.breedingId,
        RecordBirthRequest(
          actualBirthDate: DateUtils.dateOnly(_birthDate),
          kitsBorn: kits,
          activeBorn: alive,
          maleKits: male,
          femaleKits: female,
        ),
      ),
    );

    Navigator.pop(context);
  }
}
