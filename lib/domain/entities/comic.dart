import 'package:equatable/equatable.dart';

class Comic extends Equatable {
  const Comic({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.coverImage,
    required this.genres,
    required this.rating,
    required this.status,
    required this.chapterCount,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String author;
  final String coverImage;
  final List<String> genres;
  final double rating;
  final String status;
  final int chapterCount;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        author,
        coverImage,
        genres,
        rating,
        status,
        chapterCount,
        createdAt
      ];
}
