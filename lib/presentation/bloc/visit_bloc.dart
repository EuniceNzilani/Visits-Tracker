import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/visit_repository.dart';
import '../../data/models/visit.dart';

// Events
abstract class VisitEvent {}

class LoadVisits extends VisitEvent {}

class CreateVisit extends VisitEvent {
  final Visit visit;
  CreateVisit(this.visit);
}

class LoadVisitStatistics extends VisitEvent {}

// States
abstract class VisitState {}

class VisitInitial extends VisitState {}

class VisitLoading extends VisitState {}

class VisitsLoaded extends VisitState {
  final List<Visit> visits;
  VisitsLoaded(this.visits);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitsLoaded &&
          runtimeType == other.runtimeType &&
          visits == other.visits;

  @override
  int get hashCode => visits.hashCode;
}

class VisitStatisticsLoaded extends VisitState {
  final Map<String, int> statistics;
  VisitStatisticsLoaded(this.statistics);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitStatisticsLoaded &&
          runtimeType == other.runtimeType &&
          statistics == other.statistics;

  @override
  int get hashCode => statistics.hashCode;
}

class VisitError extends VisitState {
  final String message;
  VisitError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

// BLoC
class VisitBloc extends Bloc<VisitEvent, VisitState> {
  final VisitRepository _repository;

  VisitBloc(this._repository) : super(VisitInitial()) {
    on<LoadVisits>(_onLoadVisits);
    on<CreateVisit>(_onCreateVisit);
    on<LoadVisitStatistics>(_onLoadVisitStatistics);
  }

  Future<void> _onLoadVisits(LoadVisits event, Emitter<VisitState> emit) async {
    emit(VisitLoading());
    try {
      final visits = await _repository.getVisits();
      emit(VisitsLoaded(visits));
    } catch (e) {
      emit(VisitError('Failed to load visits: ${e.toString()}'));
    }
  }

  Future<void> _onCreateVisit(
    CreateVisit event,
    Emitter<VisitState> emit,
  ) async {
    emit(VisitLoading());
    try {
      await _repository.createVisit(event.visit);
      final visits = await _repository.getVisits();
      emit(VisitsLoaded(visits));
    } catch (e) {
      emit(VisitError('Failed to create visit: ${e.toString()}'));
    }
  }

  Future<void> _onLoadVisitStatistics(
    LoadVisitStatistics event,
    Emitter<VisitState> emit,
  ) async {
    emit(VisitLoading());
    try {
      final statistics = await _repository.getVisitStatistics();
      emit(VisitStatisticsLoaded(statistics));
    } catch (e) {
      emit(VisitError('Failed to load statistics: ${e.toString()}'));
    }
  }
}
