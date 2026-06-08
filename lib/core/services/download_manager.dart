import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ChapterDownloadTask {
  const ChapterDownloadTask({
    required this.id,
    required this.urls,
    required this.onProgress,
  });

  final String id;
  final List<String> urls;
  final void Function(double progress) onProgress;
}

class DownloadManager {
  final Map<String, CancelToken> _tokens = {};

  Future<Directory> comicDirectory(String comicId, String chapterId) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/comicverse/$comicId/$chapterId');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<List<String>> downloadChapter({
    required Dio dio,
    required ChapterDownloadTask task,
    required String comicId,
    required String chapterId,
  }) async {
    final dir = await comicDirectory(comicId, chapterId);
    final token = CancelToken();
    _tokens[task.id] = token;
    final files = <String>[];

    for (var index = 0; index < task.urls.length; index++) {
      final url = task.urls[index];
      final filePath = '${dir.path}/page_${index + 1}.jpg';
      await dio.download(
        url,
        filePath,
        cancelToken: token,
        onReceiveProgress: (received, total) {
          final pageWeight = 1 / task.urls.length;
          final pageProgress = total <= 0 ? 0 : received / total;
          task.onProgress((index * pageWeight) + (pageProgress * pageWeight));
        },
      );
      files.add(filePath);
    }

    _tokens.remove(task.id);
    return files;
  }

  void pause(String taskId) {
    _tokens[taskId]?.cancel('Paused by user');
    _tokens.remove(taskId);
  }
}
