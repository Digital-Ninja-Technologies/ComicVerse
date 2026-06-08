import 'package:dio/dio.dart';

import '../../core/services/download_manager.dart';
import '../../core/services/local_store.dart';
import '../../domain/entities/chapter.dart';
import '../../domain/entities/download_item.dart';
import '../../domain/repositories/download_repository.dart';
import '../models/download_model.dart';

class DownloadRepositoryImpl implements DownloadRepository {
  DownloadRepositoryImpl({
    required this.dio,
    required this.localStore,
    required this.downloadManager,
  });

  final Dio dio;
  final LocalStore localStore;
  final DownloadManager downloadManager;

  @override
  Future<List<DownloadItem>> all() async {
    return localStore.downloads.values
        .map((item) => DownloadModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Stream<DownloadItem> downloadChapter({
    required String userId,
    required String comicId,
    required Chapter chapter,
  }) async* {
    final id = '$userId-${chapter.id}';
    var item = DownloadModel(
      id: id,
      userId: userId,
      comicId: comicId,
      chapterId: chapter.id,
      downloadStatus: DownloadStatus.downloading,
      downloadedAt: DateTime.now(),
    );
    await localStore.downloads.put(id, item.toJson());
    yield item;

    final pages = await downloadManager.downloadChapter(
      dio: dio,
      comicId: comicId,
      chapterId: chapter.id,
      task: ChapterDownloadTask(
        id: id,
        urls: chapter.pages,
        onProgress: (progress) {
          item = DownloadModel(
            id: id,
            userId: userId,
            comicId: comicId,
            chapterId: chapter.id,
            downloadStatus: DownloadStatus.downloading,
            downloadedAt: DateTime.now(),
            progress: progress,
          );
          localStore.downloads.put(id, item.toJson());
        },
      ),
    );

    final completed = item.copyWith(
      downloadStatus: DownloadStatus.completed,
      progress: 1,
      localPages: pages,
    );
    await localStore.downloads.put(
        id,
        DownloadModel(
          id: completed.id,
          userId: completed.userId,
          comicId: completed.comicId,
          chapterId: completed.chapterId,
          downloadStatus: completed.downloadStatus,
          downloadedAt: completed.downloadedAt,
          progress: completed.progress,
          localPages: completed.localPages,
        ).toJson());
    yield completed;
  }

  @override
  Future<void> pause(String downloadId) async {
    downloadManager.pause(downloadId);
    final item = localStore.downloads.get(downloadId);
    if (item != null) {
      await localStore.downloads.put(
          downloadId, {...item, 'downloadStatus': DownloadStatus.paused.name});
    }
  }

  @override
  Future<void> delete(String downloadId) =>
      localStore.downloads.delete(downloadId);
}
