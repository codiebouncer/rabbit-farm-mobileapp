import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/repository/breeding_repository.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/rabbit_search_model.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/presentation/widgets/search_dropdown_field.dart';

import '../../data/models/create_breeding_request.dart';
import '../../../../core/di/service_locator.dart';

import '../bloc/breeding_bloc.dart';
import '../bloc/breeding_event.dart';

class AddBreedingPage extends StatefulWidget {
  const AddBreedingPage({super.key});

  @override
  State<AddBreedingPage> createState() => _AddBreedingPageState();
}

class _AddBreedingPageState extends State<AddBreedingPage> {
  final _formKey = GlobalKey<FormState>();

  final _notesController = TextEditingController();

  final _repository = sl<BreedingRepository>();

  String? _doeRabbitId;
  String? _buckRabbitId;

  DateTime? _crossingDate;

  bool _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _crossingDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_doeRabbitId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select Doe Rabbit')));
      return;
    }

    if (_buckRabbitId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select Buck Rabbit')));
      return;
    }

    if (_crossingDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select Crossing Date')));
      return;
    }

    setState(() {
      _saving = true;
    });

    final request = CreateBreedingRequest(
      breedingId: DateTime.now().millisecondsSinceEpoch.toString(),
      doeRabbitId: _doeRabbitId!,
      buckRabbitId: _buckRabbitId!,
      crossingDate: DateFormat('yyyy-MM-dd').format(_crossingDate!),
      notes: _notesController.text.trim(),
    );

    context.read<BreedingBloc>().add(CreateBreeding(request));

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Breeding')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchDropdownField<RabbitSearchModel>(
                label: 'Doe Rabbit',
                onSearch: _repository.searchRabbits,
                displayText: (rabbit) => rabbit.rabbitId,
                onSelected: (rabbit) {
                  _doeRabbitId = rabbit.rabbitId;
                },
              ),

              const SizedBox(height: 20),

              SearchDropdownField<RabbitSearchModel>(
                label: 'Buck Rabbit',
                onSearch: _repository.searchRabbits,
                displayText: (rabbit) => rabbit.rabbitId,
                onSelected: (rabbit) {
                  _buckRabbitId = rabbit.rabbitId;
                },
              ),

              const SizedBox(height: 20),

              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Crossing Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _crossingDate == null
                        ? 'Select Date'
                        : DateFormat('dd MMM yyyy').format(_crossingDate!),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 55,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.favorite),
                  label: Text(_saving ? 'Saving...' : 'Create Breeding'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
