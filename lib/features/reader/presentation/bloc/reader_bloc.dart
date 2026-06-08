import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/chapter.dart';
import '../../../../domain/repositories/comic_repository.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  ReaderBloc(this._repository) : super(const ReaderState()) {
    on<ReaderOpened>(_onOpened);
    on<ReaderPageChanged>(_onPageChanged);
    on<ReaderModeChanged>(
        (event, emit) => emit(state.copyWith(isVertical: event.isVertical)));
    on<ReaderNightModeToggled>(
        (event, emit) => emit(state.copyWith(nightMode: !state.nightMode)));
  }

  final ComicRepository _repository;

  Future<void> _onOpened(ReaderOpened event, Emitter<ReaderState> emit) async {
    emit(state.copyWith(status: ReaderStatus.loading));
    final chapter = await _repository.chapter(event.comicId, event.chapterId);
    final page = await _repository.readingProgress(event.chapterId);
    emit(ReaderState(
        status: ReaderStatus.success, chapter: chapter, currentPage: page));
  }

  Future<void> _onPageChanged(
      ReaderPageChanged event, Emitter<ReaderState> emit) async {
    if (state.chapter == null) return;
    await _repository.saveReadingProgress(state.chapter!.id, event.page);
    emit(state.copyWith(currentPage: event.page));
  }
}
