import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/tactical_repository.dart';
import 'simulation_state.dart';

class SimulationCubit extends Cubit<SimulationState> {
  final TacticalRepository repository;

  SimulationCubit({required this.repository}) : super(SimulationInitial());

  void executeSimulation({
    required int matchId,
    required String formation,
    required List<int> startingXi,
    required double ppda,
    required double defensiveLine,
    required double tempo,
  }) async {
    // Tahap 1 Animasi Loader
    emit(const SimulationLoading(
      statusText: 'Mengagregasikan matriks spasio-temporal starting XI...',
      progress: 0.3,
    ));

    await Future.delayed(const Duration(milliseconds: 600));

    // Tahap 2 Animasi Loader
    emit(const SimulationLoading(
      statusText: 'Menghitung inferensi probabilitas posterior Naive Bayes...',
      progress: 0.65,
    ));

    try {
      final resultFuture = repository.runSimulation(
        matchId: matchId,
        formation: formation,
        startingXi: startingXi,
        ppda: ppda,
        defensiveLine: defensiveLine,
        tempo: tempo,
      );

      await Future.delayed(const Duration(milliseconds: 600));

      // Tahap 3 Animasi Loader
      emit(const SimulationLoading(
        statusText: 'Mengekstrak lintasan aturan Explainable AI (XAI)...',
        progress: 0.95,
      ));

      final result = await resultFuture;
      await Future.delayed(const Duration(milliseconds: 400));

      emit(SimulationSuccess(result));
    } catch (e) {
      emit(SimulationError('Terjadi kesalahan komputasi taktik: ${e.toString()}'));
    }
  }

  void reset() {
    emit(SimulationInitial());
  }
}
