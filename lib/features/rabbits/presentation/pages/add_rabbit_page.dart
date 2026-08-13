import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../bloc/rabbit_bloc.dart';
import '../bloc/rabbit_event.dart';
import '../bloc/rabbit_state.dart';
import '../widgets/rabbit_form.dart';

class AddRabbitPage extends StatelessWidget {
  const AddRabbitPage({super.key});
  @override
  Widget build(BuildContext context) => BlocListener<RabbitBloc, RabbitState>(
    listenWhen: (previous, current) =>
        previous.submissionStatus != current.submissionStatus,
    listener: (context, state) {
      if (state.submissionStatus == RabbitSubmissionStatus.success &&
          state.createdRabbitId != null) {
        final rabbitId = state.createdRabbitId;
        if (rabbitId == null) return;
        context.read<RabbitBloc>().add(ResetRabbitSubmission());
        context.pushReplacement(RouteNames.rabbitDetails(rabbitId));
      }
    },
    child: Scaffold(
      appBar: AppBar(title: const Text('Add rabbit')),
      body: const SafeArea(child: RabbitForm()),
    ),
  );
}
