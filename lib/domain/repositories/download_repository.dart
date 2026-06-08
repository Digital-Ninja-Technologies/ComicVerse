import '../entities/chapter.dart';
import '../entities/download_item.dart';

abstract class DownloadRepository {
  Future<List<DownloadItem>> all();
  Stream<DownloadItem> downloadChapter({
    required String userId,
    required String comicId,
    required Chapter chapter,
  });
  Future<void> pause(String downloadId);
  Future<void> delete(String downloadId);
}
