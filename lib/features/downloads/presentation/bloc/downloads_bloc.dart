import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/chapter.dart';
import '../../../../domain/entities/download_item.dart';
import '../../../../domain/repositories/download_repository.dart';

part 'downloads_event.dart';
part 'downloads_state.dart';

class DownloadsBloc extends Bloc<DownloadsEvent, DownloadsState> {
  DownloadsBloc(this._repository) : super(const DownloadsState()) {
    on<DownloadsLoaded>(_onLoaded);
    on<DownloadChapterRequested>(_onDownload);
    on<DownloadPauseRequested>(_onPause);
    on<DownloadDeleteRequested>(_onDelete);
    on<_DownloadProgressed>(_onProgressed);
  }

  final DownloadRepository _repository;
  final List<StreamSubscription<DownloadItem>> _subscriptions = [];

  Future<void> _onLoaded(
      DownloadsLoaded event, Emitter<DownloadsState> emit) async {
    emit(state.copyWith(status: DownloadsStatus.loading));
    final items = await _repository.all();
    emit(DownloadsState(status: DownloadsStatus.success, items: items));
  }

  Future<void> _onDownload(
      DownloadChapterRequested event, Emitter<DownloadsState> emit) async {
    final subscription = _repository
        .downloadChapter(
            userId: event.userId,
            comicId: event.comicId,
            chapter: event.chapter)
        .listen((item) {
      add(_DownloadProgressed(item));
    });
    _subscriptions.add(subscription);
  }

  Future<void> _onPause(
      DownloadPauseRequested event, Emitter<DownloadsState> emit) async {
    await _repository.pause(event.id);
    add(DownloadsLoaded());
  }

  Future<void> _onDelete(
      DownloadDeleteRequested event, Emitter<DownloadsState> emit) async {
    await _repository.delete(event.id);
    add(DownloadsLoaded());
  }

  void _onProgressed(_DownloadProgressed event, Emitter<DownloadsState> emit) {
    final next = [
      ...state.items.where((item) => item.id != event.item.id),
      event.item
    ];
    emit(DownloadsState(status: DownloadsStatus.success, items: next));
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
