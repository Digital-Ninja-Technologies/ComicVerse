import '../../domain/entities/download_item.dart';

class DownloadModel extends DownloadItem {
  const DownloadModel({
    required super.id,
    required super.userId,
    required super.comicId,
    required super.chapterId,
    required super.downloadStatus,
    required super.downloadedAt,
    super.progress,
    super.localPages,
  });

  factory DownloadModel.fromJson(Map<String, dynamic> json) {
    return DownloadModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      comicId: json['comicId'] as String,
      chapterId: json['chapterId'] as String,
      downloadStatus: DownloadStatus.values.firstWhere(
        (status) => status.name == (json['downloadStatus'] as String?),
        orElse: () => DownloadStatus.queued,
      ),
      downloadedAt: DateTime.tryParse(json['downloadedAt'] as String? ?? '') ??
          DateTime.now(),
      progress: (json['progress'] as num? ?? 0).toDouble(),
      localPages: List<String>.from(json['localPages'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'comicId': comicId,
        'chapterId': chapterId,
        'downloadStatus': downloadStatus.name,
        'downloadedAt': downloadedAt.toIso8601String(),
        'progress': progress,
        'localPages': localPages,
      };
}
