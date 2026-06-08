import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/comic.dart';
import '../../../../domain/repositories/comic_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._repository) : super(const SearchState()) {
    on<SearchRequested>(_onRequested);
    on<SearchNextPageRequested>(_onNextPage);
  }

  final ComicRepository _repository;

  Future<void> _onRequested(
      SearchRequested event, Emitter<SearchState> emit) async {
    emit(SearchState(
        status: SearchStatus.loading,
        query: event.query,
        genres: event.genres,
        author: event.author));
    try {
      final results = await _repository.search(
          query: event.query, genres: event.genres, author: event.author);
      emit(SearchState(
          status: SearchStatus.success,
          query: event.query,
          genres: event.genres,
          author: event.author,
          results: results,
          page: 1,
          hasMore: results.length == 12));
    } catch (error) {
      emit(state.copyWith(
          status: SearchStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onNextPage(
      SearchNextPageRequested event, Emitter<SearchState> emit) async {
    if (!state.hasMore || state.status == SearchStatus.loadingMore) return;
    emit(state.copyWith(status: SearchStatus.loadingMore));
    final nextPage = state.page + 1;
    final results = await _repository.search(
        query: state.query,
        genres: state.genres,
        author: state.author,
        page: nextPage);
    emit(state.copyWith(
        status: SearchStatus.success,
        results: [...state.results, ...results],
        page: nextPage,
        hasMore: results.length == 12));
  }
}
