import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/models/breeding_model.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/bloc/breeding_bloc.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/bloc/breeding_event.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/bloc/breeding_state.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/widgets/breeding_activity_timeline.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/widgets/breeding_birth_summary_section.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/widgets/breeding_notes_section.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/widgets/breeding_rabbit_info_section.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/widgets/breeding_status_banner.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/widgets/breeding_timeline_section.dart';

class BreedingDetailsPage extends StatefulWidget {
  final String breedingId;

  const BreedingDetailsPage({super.key, required this.breedingId});

  @override
  State<BreedingDetailsPage> createState() => _BreedingDetailsPageState();
}

class _BreedingDetailsPageState extends State<BreedingDetailsPage> {
  @override
  void initState() {
    super.initState();
    debugPrint("Loading breeding: ${widget.breedingId}");

    context.read<BreedingBloc>().add(LoadBreedingDetails(widget.breedingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Breeding Details")),
      body: BlocBuilder<BreedingBloc, BreedingState>(
        builder: (context, state) {
          switch (state.status) {
            case BreedingStateStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case BreedingStateStatus.loaded:
              if (state.selectedBreeding == null) {
                return const Center(child: Text("Breeding not found"));
              }

              return _Body(breeding: state.selectedBreeding!);

            case BreedingStateStatus.error:
              return Center(
                child: Text(state.errorMessage ?? "Something went wrong"),
              );

            case BreedingStateStatus.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final BreedingModel breeding;

  const _Body({required this.breeding});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BreedingStatusBanner(status: breeding.status),

          BreedingRabbitInfoSection(breeding: breeding),

          BreedingTimelineSection(breeding: breeding),

          BreedingBirthSummarySection(breeding: breeding),

          BreedingNotesSection(notes: breeding.notes),

          BreedingActivityTimeline(breeding: breeding),
        ],
      ),
    );
  }
}
