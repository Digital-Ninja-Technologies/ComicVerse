import '../entities/chapter.dart';
import '../entities/comic.dart';

abstract class ComicRepository {
  Future<List<Comic>> featured();
  Future<List<Comic>> trending();
  Future<List<Comic>> popular();
  Future<List<Comic>> newReleases();
  Future<List<Comic>> search({
    required String query,
    List<String> genres = const [],
    String? author,
    int page = 1,
  });
  Future<Comic> comic(String id);
  Future<List<Chapter>> chapters(String comicId);
  Future<Chapter> chapter(String comicId, String chapterId);
  Future<void> saveReadingProgress(String chapterId, int page);
  Future<int> readingProgress(String chapterId);
}
