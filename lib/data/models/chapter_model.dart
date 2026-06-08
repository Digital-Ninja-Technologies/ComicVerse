import '../../domain/entities/chapter.dart';

class ChapterModel extends Chapter {
  const ChapterModel({
    required super.id,
    required super.comicId,
    required super.title,
    required super.chapterNumber,
    required super.pages,
    required super.createdAt,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'] as String,
      comicId: json['comicId'] as String,
      title: json['title'] as String,
      chapterNumber: (json['chapterNumber'] as num? ?? 1).toInt(),
      pages: List<String>.from(json['pages'] as List? ?? const []),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'comicId': comicId,
        'title': title,
        'chapterNumber': chapterNumber,
        'pages': pages,
        'createdAt': createdAt.toIso8601String(),
      };
}
