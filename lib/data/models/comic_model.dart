import '../../domain/entities/comic.dart';

class ComicModel extends Comic {
  const ComicModel({
    required super.id,
    required super.title,
    required super.description,
    required super.author,
    required super.coverImage,
    required super.genres,
    required super.rating,
    required super.status,
    required super.chapterCount,
    required super.createdAt,
  });

  factory ComicModel.fromJson(Map<String, dynamic> json) {
    return ComicModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      author: json['author'] as String? ?? 'Unknown',
      coverImage: json['coverImage'] as String? ?? '',
      genres: List<String>.from(json['genres'] as List? ?? const []),
      rating: (json['rating'] as num? ?? 0).toDouble(),
      status: json['status'] as String? ?? 'Ongoing',
      chapterCount: (json['chapterCount'] as num? ?? 0).toInt(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'author': author,
        'coverImage': coverImage,
        'genres': genres,
        'rating': rating,
        'status': status,
        'chapterCount': chapterCount,
        'createdAt': createdAt.toIso8601String(),
      };
}
