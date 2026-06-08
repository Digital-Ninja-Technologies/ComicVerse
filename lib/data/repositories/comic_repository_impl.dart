import '../../core/services/api_service.dart';
import '../../core/services/local_store.dart';
import '../../domain/entities/chapter.dart';
import '../../domain/entities/comic.dart';
import '../../domain/repositories/comic_repository.dart';
import '../models/chapter_model.dart';
import '../models/comic_model.dart';
import 'mock_catalog.dart';

class ComicRepositoryImpl implements ComicRepository {
  ComicRepositoryImpl({required this.api, required this.localStore});

  final ApiService api;
  final LocalStore localStore;

  @override
  Future<List<Comic>> featured() async =>
      _catalog().then((items) => items.take(3).toList());

  @override
  Future<List<Comic>> trending() async => _catalog();

  @override
  Future<List<Comic>> popular() async {
    final items = await _catalog();
    items.sort((a, b) => b.rating.compareTo(a.rating));
    return items;
  }

  @override
  Future<List<Comic>> newReleases() async {
    final items = await _catalog();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Future<List<Comic>> search({
    required String query,
    List<String> genres = const [],
    String? author,
    int page = 1,
  }) async {
    if (query.trim().isNotEmpty) {
      await localStore.recentSearches
          .put(DateTime.now().microsecondsSinceEpoch, query.trim());
    }
    final needle = query.trim().toLowerCase();
    final all = await _catalog();
    return all
        .where((comic) {
          final matchesQuery = needle.isEmpty ||
              comic.title.toLowerCase().contains(needle) ||
              comic.description.toLowerCase().contains(needle) ||
              comic.author.toLowerCase().contains(needle);
          final matchesGenre =
              genres.isEmpty || genres.any(comic.genres.contains);
          final matchesAuthor = author == null ||
              author.isEmpty ||
              comic.author.toLowerCase().contains(author.toLowerCase());
          return matchesQuery && matchesGenre && matchesAuthor;
        })
        .skip((page - 1) * 12)
        .take(12)
        .toList();
  }

  @override
  Future<Comic> comic(String id) async =>
      (await _catalog()).firstWhere((comic) => comic.id == id);

  @override
  Future<List<Chapter>> chapters(String comicId) async {
    final cached = localStore.chapters.values
        .where((item) => item['comicId'] == comicId)
        .map((item) => ChapterModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    if (cached.isNotEmpty) return cached;

    final generated = mockChapters(comicId);
    for (final chapter in generated) {
      await localStore.chapters.put(chapter.id, chapter.toJson());
    }
    return generated;
  }

  @override
  Future<Chapter> chapter(String comicId, String chapterId) async {
    return (await chapters(comicId))
        .firstWhere((chapter) => chapter.id == chapterId);
  }

  @override
  Future<void> saveReadingProgress(String chapterId, int page) async {
    await localStore.progress
        .put(chapterId, {'chapterId': chapterId, 'page': page});
  }

  @override
  Future<int> readingProgress(String chapterId) async {
    return (localStore.progress.get(chapterId)?['page'] as int?) ?? 0;
  }

  Future<List<ComicModel>> _catalog() async {
    if (localStore.comics.isNotEmpty) {
      return localStore.comics.values
          .map((item) => ComicModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    for (final comic in mockComics) {
      await localStore.comics.put(comic.id, comic.toJson());
    }
    return mockComics;
  }
}
