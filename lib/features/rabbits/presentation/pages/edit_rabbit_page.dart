import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/app_state_panel.dart';
import '../bloc/rabbit_bloc.dart';
import '../bloc/rabbit_event.dart';
import '../bloc/rabbit_state.dart';
import '../widgets/rabbit_form.dart';

class EditRabbitPage extends StatefulWidget {
  final String rabbitId;
  const EditRabbitPage({required this.rabbitId, super.key});
  @override
  State<EditRabbitPage> createState() => _EditRabbitPageState();
}

class _EditRabbitPageState extends State<EditRabbitPage> {
  @override
  void initState() {
    super.initState();
    context.read<RabbitBloc>().add(LoadRabbitDetails(widget.rabbitId));
  }

  @override
  Widget build(BuildContext context) => BlocListener<RabbitBloc, RabbitState>(
    listenWhen: (previous, current) =>
        previous.submissionStatus != current.submissionStatus,
    listener: (context, state) {
      if (state.submissionStatus == RabbitSubmissionStatus.success) {
        context.read<RabbitBloc>().add(ResetRabbitSubmission());
        context.pop(true);
      }
    },
    child: Scaffold(
      appBar: AppBar(title: const Text('Edit rabbit')),
      body: BlocBuilder<RabbitBloc, RabbitState>(
        builder: (context, state) => switch (state.detailsStatus) {
          RabbitDetailsStatus.loading ||
          RabbitDetailsStatus.initial => const AppStatePanel.loading(),
          RabbitDetailsStatus.failure => AppStatePanel(
            kind: state.detailsFailureKind == AppFailureKind.offline
                ? AppStateKind.offline
                : AppStateKind.error,
            message: state.detailsMessage,
            onAction: () => context.read<RabbitBloc>().add(
              LoadRabbitDetails(widget.rabbitId),
            ),
          ),
          RabbitDetailsStatus.success =>
            state.profile == null
                ? AppStatePanel(
                    kind: AppStateKind.error,
                    onAction: () => context.read<RabbitBloc>().add(
                      LoadRabbitDetails(widget.rabbitId),
                    ),
                  )
                : RabbitForm(initialRabbit: state.profile?.rabbit),
        },
      ),
    ),
  );
}
