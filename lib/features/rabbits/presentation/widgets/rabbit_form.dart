import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/breed_search_model.dart';
import '../../data/models/cage_search_model.dart';
import '../../data/models/create_rabbbit_request.dart';
import '../../data/models/rabbit_details_model.dart';
import '../../data/models/rabbit_search_model.dart';
import '../../data/models/supplier_search_model.dart';
import '../../data/models/update_rabbit.dart';
import '../bloc/rabbit_bloc.dart';
import '../bloc/rabbit_event.dart';
import '../bloc/rabbit_state.dart';
import 'search_dropdown_field.dart';

class RabbitForm extends StatefulWidget {
  final RabbitDetailsModel? initialRabbit;
  const RabbitForm({this.initialRabbit, super.key});
  @override
  State<RabbitForm> createState() => _RabbitFormState();
}

class _RabbitFormState extends State<RabbitForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _markings;
  late final TextEditingController _notes;
  late String _gender;
  late String _stage;
  late String _status;
  late int? _breedId;
  late int? _supplierId;
  late String? _cageId;
  late String? _motherRabbitId;
  late String? _fatherRabbitId;
  late DateTime? _dateOfBirth;
  bool _attempted = false;

  bool get _editing => widget.initialRabbit != null;

  @override
  void initState() {
    super.initState();
    final rabbit = widget.initialRabbit;
    _gender = rabbit?.gender ?? 'Female';
    _stage = rabbit?.stage ?? 'Adult';
    _status = rabbit?.status ?? 'Active';
    _breedId = rabbit?.breedId;
    _supplierId = rabbit?.supplierId;
    _cageId = rabbit?.cageId;
    _motherRabbitId = rabbit?.motherRabbitId;
    _fatherRabbitId = rabbit?.fatherRabbitId;
    _dateOfBirth = DateTime.tryParse(rabbit?.dateOfBirth ?? '');
    _markings = TextEditingController(text: rabbit?.colorMarkings ?? '');
    _notes = TextEditingController(text: rabbit?.notes ?? '');
  }

  @override
  void dispose() {
    _markings.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      initialDate: _dateOfBirth ?? DateTime.now(),
    );
    if (selected != null && mounted) setState(() => _dateOfBirth = selected);
  }

  void _submit() {
    setState(() => _attempted = true);
    final form = _formKey.currentState;
    if (form == null ||
        !form.validate() ||
        _breedId == null ||
        _cageId == null ||
        _dateOfBirth == null) {
      return;
    }
    final birthDate = _dateOfBirth;
    if (birthDate == null) return;
    final date = DateFormat('yyyy-MM-dd').format(birthDate);
    final bloc = context.read<RabbitBloc>();
    if (_editing) {
      bloc.add(
        UpdateRabbit(
          widget.initialRabbit?.rabbitId ?? '',
          UpdateRabbitRequest(
            gender: _gender,
            breedId: _breedId,
            dateOfBirth: date,
            supplierId: _supplierId,
            cageId: _cageId,
            status: _status,
            stage: _stage,
            colorMarkings: _nullable(_markings.text),
            notes: _nullable(_notes.text),
            motherRabbitId: _motherRabbitId,
            fatherRabbitId: _fatherRabbitId,
          ),
        ),
      );
    } else {
      bloc.add(
        CreateRabbit(
          CreateRabbitRequest(
            gender: _gender,
            breedId: _breedId,
            dateOfBirth: date,
            supplierId: _supplierId,
            cageId: _cageId,
            status: _status,
            motherRabbitId: _motherRabbitId,
            fatherRabbitId: _fatherRabbitId,
            stage: _stage,
            colorMarkings: _nullable(_markings.text),
            notes: _nullable(_notes.text),
          ),
        ),
      );
    }
  }

  String? _nullable(String value) => value.trim().isEmpty ? null : value.trim();
  String? _fieldError(RabbitState state, String name) =>
      state.fieldErrors[name.toLowerCase()]?.firstOrNull;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<RabbitBloc>().repository;
    return BlocBuilder<RabbitBloc, RabbitState>(
      builder: (context, state) {
        final submitting =
            state.submissionStatus == RabbitSubmissionStatus.submitting;
        return Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _SectionHeader(title: 'Identity', trailing: 'Required fields *'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                initialValue:
                    widget.initialRabbit?.rabbitId ?? 'Generated after save',
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Rabbit code',
                  helperText: 'Codes are generated from the selected cage.',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const _SectionHeader(title: 'Animal profile'),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Female', label: Text('Female')),
                  ButtonSegment(value: 'Male', label: Text('Male')),
                ],
                selected: {_gender},
                onSelectionChanged: submitting
                    ? null
                    : (values) => setState(() => _gender = values.first),
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(
                    const Size(0, AppSpacing.touchTarget),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SearchDropdownField<BreedSearchModel>(
                label: 'Breed',
                required: true,
                initialText: widget.initialRabbit?.breedName,
                errorText:
                    _fieldError(state, 'breedId') ??
                    (_attempted && _breedId == null ? 'Select a breed.' : null),
                onSearch: repository.searchBreeds,
                displayText: (breed) => breed.breedName,
                onSelected: (breed) => setState(() => _breedId = breed.breedId),
                onCleared: () => setState(() => _breedId = null),
              ),
              const SizedBox(height: AppSpacing.md),
              _DateField(
                date: _dateOfBirth,
                label: 'Date of birth *',
                error:
                    _fieldError(state, 'dateOfBirth') ??
                    (_attempted && _dateOfBirth == null
                        ? 'Select a date of birth.'
                        : null),
                onTap: submitting ? null : _pickDate,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: _stage,
                decoration: InputDecoration(
                  labelText: 'Stage *',
                  errorText: _fieldError(state, 'stage'),
                ),
                items: const ['Kit', 'Weaner', 'Grower', 'Adult']
                    .map(
                      (value) =>
                          DropdownMenuItem(value: value, child: Text(value)),
                    )
                    .toList(),
                onChanged: submitting
                    ? null
                    : (value) => setState(() => _stage = value ?? _stage),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _SectionHeader(title: 'Housing and source'),
              const SizedBox(height: AppSpacing.sm),
              if (_editing)
                TextFormField(
                  initialValue: widget.initialRabbit?.cageId ?? 'Not assigned',
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Cage'),
                )
              else
                SearchDropdownField<CageSearchModel>(
                  label: 'Cage',
                  required: true,
                  errorText:
                      _fieldError(state, 'cageId') ??
                      (_attempted && _cageId == null ? 'Select a cage.' : null),
                  onSearch: repository.searchCages,
                  displayText: (cage) => cage.cageId,
                  onSelected: (cage) => setState(() => _cageId = cage.cageId),
                  onCleared: () => setState(() => _cageId = null),
                ),
              if (_editing) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Use “Move cage” on rabbit details to change housing.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.purple),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              SearchDropdownField<SupplierSearchModel>(
                label: 'Supplier',
                initialText: widget.initialRabbit?.supplierName,
                errorText: _fieldError(state, 'supplierId'),
                onSearch: repository.searchSuppliers,
                displayText: (supplier) => supplier.supplierName,
                onSelected: (supplier) =>
                    setState(() => _supplierId = supplier.supplierId),
                onCleared: () => setState(() => _supplierId = null),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _SectionHeader(title: 'Parentage'),
              const SizedBox(height: AppSpacing.sm),
              SearchDropdownField<RabbitSearchModel>(
                label: 'Dam (female)',
                initialText: widget.initialRabbit?.motherRabbitId,
                errorText: _fieldError(state, 'motherRabbitId'),
                onSearch: repository.searchRabbits,
                displayText: (rabbit) => rabbit.rabbitId,
                onSelected: (rabbit) =>
                    setState(() => _motherRabbitId = rabbit.rabbitId),
                onCleared: () => setState(() => _motherRabbitId = null),
              ),
              const SizedBox(height: AppSpacing.md),
              SearchDropdownField<RabbitSearchModel>(
                label: 'Sire (male)',
                initialText: widget.initialRabbit?.fatherRabbitId,
                errorText: _fieldError(state, 'fatherRabbitId'),
                onSearch: repository.searchRabbits,
                displayText: (rabbit) => rabbit.rabbitId,
                onSelected: (rabbit) =>
                    setState(() => _fatherRabbitId = rabbit.rabbitId),
                onCleared: () => setState(() => _fatherRabbitId = null),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _SectionHeader(title: 'Additional details'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _markings,
                maxLength: 200,
                decoration: InputDecoration(
                  labelText: 'Color or markings',
                  hintText: 'White with brown ears',
                  errorText: _fieldError(state, 'colorMarkings'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _notes,
                minLines: 3,
                maxLines: 5,
                maxLength: 1000,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Temperament, acquisition, or care notes',
                  errorText: _fieldError(state, 'notes'),
                ),
              ),
              if (state.submissionStatus == RabbitSubmissionStatus.failure) ...[
                const SizedBox(height: AppSpacing.md),
                _ValidationAlert(
                  message:
                      state.submissionMessage ??
                      'Check the highlighted fields and try again.',
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: submitting
                          ? null
                          : () => Navigator.maybePop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: _editing ? 'Save changes' : 'Save rabbit',
                      onPressed: _submit,
                      loading: submitting,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  const _SectionHeader({required this.title, this.trailing});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      if (trailing != null)
        Text(
          trailing!,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: AppColors.purple),
        ),
    ],
  );
}

class _DateField extends StatelessWidget {
  final DateTime? date;
  final String label;
  final String? error;
  final VoidCallback? onTap;
  const _DateField({
    required this.date,
    required this.label,
    required this.onTap,
    this.error,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(AppRadius.medium),
    onTap: onTap,
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
        suffixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      child: Text(
        date == null ? 'Select date' : DateFormat('d MMM yyyy').format(date!),
      ),
    ),
  );
}

class _ValidationAlert extends StatelessWidget {
  final String message;
  const _ValidationAlert({required this.message});
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorSurface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    ),
  );
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
