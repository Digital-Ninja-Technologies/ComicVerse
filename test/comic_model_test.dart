import 'package:comicverse/data/models/comic_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ComicModel serializes from and to json', () {
    final createdAt = DateTime(2026, 1, 1);
    final comic = ComicModel.fromJson({
      'id': 'aurora-wars',
      'title': 'Aurora Wars',
      'description': 'A city-of-light adventure.',
      'author': 'Mina Vale',
      'coverImage': 'https://example.com/cover.jpg',
      'genres': ['Action', 'Fantasy'],
      'rating': 4.8,
      'status': 'Ongoing',
      'chapterCount': 32,
      'createdAt': createdAt.toIso8601String(),
    });

    expect(comic.title, 'Aurora Wars');
    expect(comic.genres, contains('Fantasy'));
    expect(comic.toJson()['chapterCount'], 32);
  });
}
