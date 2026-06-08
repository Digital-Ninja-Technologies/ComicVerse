import 'package:equatable/equatable.dart';

enum DownloadStatus { queued, downloading, paused, completed, failed }

class DownloadItem extends Equatable {
  const DownloadItem({
    required this.id,
    required this.userId,
    required this.comicId,
    required this.chapterId,
    required this.downloadStatus,
    required this.downloadedAt,
    this.progress = 0,
    this.localPages = const [],
  });

  final String id;
  final String userId;
  final String comicId;
  final String chapterId;
  final DownloadStatus downloadStatus;
  final DateTime downloadedAt;
  final double progress;
  final List<String> localPages;

  DownloadItem copyWith({
    DownloadStatus? downloadStatus,
    DateTime? downloadedAt,
    double? progress,
    List<String>? localPages,
  }) {
    return DownloadItem(
      id: id,
      userId: userId,
      comicId: comicId,
      chapterId: chapterId,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      progress: progress ?? this.progress,
      localPages: localPages ?? this.localPages,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        comicId,
        chapterId,
        downloadStatus,
        downloadedAt,
        progress,
        localPages
      ];
}
