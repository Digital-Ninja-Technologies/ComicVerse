part of 'reader_bloc.dart';

enum ReaderStatus { initial, loading, success, failure }

class ReaderState extends Equatable {
  const ReaderState({
    this.status = ReaderStatus.initial,
    this.chapter,
    this.currentPage = 0,
    this.isVertical = true,
    this.nightMode = false,
  });

  final ReaderStatus status;
  final Chapter? chapter;
  final int currentPage;
  final bool isVertical;
  final bool nightMode;

  ReaderState copyWith(
      {ReaderStatus? status,
      Chapter? chapter,
      int? currentPage,
      bool? isVertical,
      bool? nightMode}) {
    return ReaderState(
      status: status ?? this.status,
      chapter: chapter ?? this.chapter,
      currentPage: currentPage ?? this.currentPage,
      isVertical: isVertical ?? this.isVertical,
      nightMode: nightMode ?? this.nightMode,
    );
  }

  @override
  List<Object?> get props =>
      [status, chapter, currentPage, isVertical, nightMode];
}
