import 'package:equatable/equatable.dart';
import '../../data/models/simulation_result_model.dart';

abstract class SimulationState extends Equatable {
  const SimulationState();

  @override
  List<Object?> get props => [];
}

class SimulationInitial extends SimulationState {}

class SimulationLoading extends SimulationState {
  final String statusText;
  final double progress;

  const SimulationLoading({
    this.statusText = 'Memproses data spasio-temporal...',
    this.progress = 0.2,
  });

  @override
  List<Object?> get props => [statusText, progress];
}

class SimulationSuccess extends SimulationState {
  final SimulationResultModel result;

  const SimulationSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class SimulationError extends SimulationState {
  final String message;

  const SimulationError(this.message);

  @override
  List<Object?> get props => [message];
}
