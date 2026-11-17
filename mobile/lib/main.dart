import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/colors.dart';
import 'core/theme/typography.dart';
import 'data/repositories/tactical_repository.dart';
import 'logic/tactical_board/tactical_board_cubit.dart';
import 'logic/simulation/simulation_cubit.dart';
import 'presentation/screens/home_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BarcaTacticalPlannerApp());
}

class BarcaTacticalPlannerApp extends StatelessWidget {
  const BarcaTacticalPlannerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tacticalRepository = TacticalRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: tacticalRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TacticalBoardCubit>(
            create: (context) => TacticalBoardCubit(
              repository: tacticalRepository,
            )..loadInitialSquad(),
          ),
          BlocProvider<SimulationCubit>(
            create: (context) => SimulationCubit(
              repository: tacticalRepository,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Barça Tactical Planner',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: BarcaColors.obsidianCanvas,
            primaryColor: BarcaColors.royalBlue,
            colorScheme: const ColorScheme.dark(
              primary: BarcaColors.royalBlue,
              secondary: BarcaColors.deepCrimson,
              surface: BarcaColors.surfaceTier1,
            ),
            textTheme: TextTheme(
              headlineMedium: BarcaTypography.headlineMd,
              bodyMedium: BarcaTypography.bodyMd,
            ),
          ),
          home: const HomeDashboardScreen(),
        ),
      ),
    );
  }
}
