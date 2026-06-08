import 'package:equatable/equatable.dart';

class Chapter extends Equatable {
  const Chapter({
    required this.id,
    required this.comicId,
    required this.title,
    required this.chapterNumber,
    required this.pages,
    required this.createdAt,
  });

  final String id;
  final String comicId;
  final String title;
  final int chapterNumber;
  final List<String> pages;
  final DateTime createdAt;

  @override
  List<Object?> get props =>
      [id, comicId, title, chapterNumber, pages, createdAt];
}
