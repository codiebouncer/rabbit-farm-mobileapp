import 'package:flutter/material.dart';

class MarkSoldResult {
  final double amount;
  final String buyerName;
  final String buyerContact;

  const MarkSoldResult({
    required this.amount,
    required this.buyerName,
    required this.buyerContact,
  });
}

class MarkSoldDialog extends StatefulWidget {
  const MarkSoldDialog({super.key});

  @override
  State<MarkSoldDialog> createState() => _MarkSoldDialogState();
}

class _MarkSoldDialogState extends State<MarkSoldDialog> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final buyerController = TextEditingController();
  final contactController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    buyerController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record rabbit sale'),

      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This changes the rabbit’s status to Sold and creates a sales-history record.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: buyerController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Buyer name *'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter the buyer name.'
                    : value.trim().length > 150
                    ? 'Use 150 characters or fewer.'
                    : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Buyer Contact'),
                keyboardType: TextInputType.phone,
                validator: (value) => (value?.trim().length ?? 0) > 30
                    ? 'Use 30 characters or fewer.'
                    : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Sale amount *',
                  prefixText: 'GH₵ ',
                ),
                validator: (value) {
                  final amount = double.tryParse(value?.trim() ?? '');
                  return amount == null || amount <= 0
                      ? 'Enter an amount greater than zero.'
                      : null;
                },
              ),
            ],
          ),
        ),
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
            final form = _formKey.currentState;
            if (form == null || !form.validate()) return;
            final amount = double.tryParse(amountController.text.trim());
            if (amount == null) return;
            Navigator.pop(
              context,
              MarkSoldResult(
                amount: amount,
                buyerName: buyerController.text.trim(),
                buyerContact: contactController.text.trim(),
              ),
            );
          },
          child: const Text('Record sale'),
        ),
      ],
    );
  }
}
