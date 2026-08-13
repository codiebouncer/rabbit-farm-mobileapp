import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/service_locator.dart';
import '../../core/routes/navigation_cubit.dart';
import '../../core/routes/navigation_state.dart';
import '../../features/breeding/presentation/bloc/breeding_bloc.dart';
import '../../features/breeding/presentation/bloc/breeding_event.dart';
import '../../features/breeding/presentation/pages/breeding_page.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_event.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/more/presentation/page/more_page.dart';
import '../../features/rabbits/presentation/bloc/rabbit_bloc.dart';
import '../../features/rabbits/presentation/bloc/rabbit_event.dart';
import '../../features/rabbits/presentation/pages/rabbits_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NavigationCubit>()),
        BlocProvider(
          create: (_) => sl<DashboardBloc>()..add(DashboardLoaded()),
        ),
        BlocProvider(create: (_) => sl<RabbitBloc>()..add(LoadRabbits())),
        BlocProvider(create: (_) => sl<BreedingBloc>()..add(LoadBreedings())),
      ],
      child: const _MainNavigationView(),
    );
  }
}

class _MainNavigationView extends StatelessWidget {
  const _MainNavigationView();
  static const pages = [
    DashboardPage(),
    RabbitsPage(),
    BreedingPage(),
    ReportsPage(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) => Scaffold(
          body: IndexedStack(index: state.currentIndex, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: state.currentIndex,
            onDestinationSelected: context.read<NavigationCubit>().changeTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.pets_outlined),
                selectedIcon: Icon(Icons.pets),
                label: 'Rabbits',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: 'Breeding',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: 'Reports',
              ),
              NavigationDestination(icon: Icon(Icons.menu), label: 'More'),
            ],
          ),
        ),
      );
}
