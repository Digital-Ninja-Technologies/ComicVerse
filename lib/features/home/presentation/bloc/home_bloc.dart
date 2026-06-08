import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/comic.dart';
import '../../../../domain/repositories/comic_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(const HomeState()) {
    on<HomeRequested>(_onRequested);
  }

  final ComicRepository _repository;

  Future<void> _onRequested(
      HomeRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final results = await Future.wait([
        _repository.featured(),
        _repository.trending(),
        _repository.popular(),
        _repository.newReleases(),
      ]);
      emit(HomeState(
        status: HomeStatus.success,
        featured: results[0],
        trending: results[1],
        popular: results[2],
        newReleases: results[3],
        continueReading: results[1].take(2).toList(),
      ));
    } catch (error) {
      emit(state.copyWith(
          status: HomeStatus.failure, message: error.toString()));
    }
  }
}
