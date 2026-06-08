part of 'reader_bloc.dart';

sealed class ReaderEvent extends Equatable {
  const ReaderEvent();
  @override
  List<Object?> get props => [];
}

class ReaderOpened extends ReaderEvent {
  const ReaderOpened(this.comicId, this.chapterId);
  final String comicId;
  final String chapterId;
  @override
  List<Object?> get props => [comicId, chapterId];
}

class ReaderPageChanged extends ReaderEvent {
  const ReaderPageChanged(this.page);
  final int page;
  @override
  List<Object?> get props => [page];
}

class ReaderModeChanged extends ReaderEvent {
  const ReaderModeChanged(this.isVertical);
  final bool isVertical;
  @override
  List<Object?> get props => [isVertical];
}

class ReaderNightModeToggled extends ReaderEvent {}
