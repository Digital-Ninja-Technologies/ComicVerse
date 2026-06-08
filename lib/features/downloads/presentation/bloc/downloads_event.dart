part of 'downloads_bloc.dart';

sealed class DownloadsEvent extends Equatable {
  const DownloadsEvent();
  @override
  List<Object?> get props => [];
}

class DownloadsLoaded extends DownloadsEvent {}

class DownloadChapterRequested extends DownloadsEvent {
  const DownloadChapterRequested(
      {required this.userId, required this.comicId, required this.chapter});
  final String userId;
  final String comicId;
  final Chapter chapter;
  @override
  List<Object?> get props => [userId, comicId, chapter];
}

class DownloadPauseRequested extends DownloadsEvent {
  const DownloadPauseRequested(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class DownloadDeleteRequested extends DownloadsEvent {
  const DownloadDeleteRequested(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class _DownloadProgressed extends DownloadsEvent {
  const _DownloadProgressed(this.item);
  final DownloadItem item;
  @override
  List<Object?> get props => [item];
}
