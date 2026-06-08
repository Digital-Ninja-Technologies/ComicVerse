import '../models/chapter_model.dart';
import '../models/comic_model.dart';

final mockComics = <ComicModel>[
  ComicModel(
    id: 'aurora-wars',
    title: 'Aurora Wars',
    description:
        'A street-level artist discovers a city of light under Lagos and must defend both worlds from a syndicate stealing memory crystals.',
    author: 'Mina Vale',
    coverImage:
        'https://images.unsplash.com/photo-1541562232579-512a21360020?w=900',
    genres: const ['Action', 'Fantasy', 'Afrofuturism'],
    rating: 4.8,
    status: 'Ongoing',
    chapterCount: 32,
    createdAt: DateTime(2026, 1, 18),
  ),
  ComicModel(
    id: 'midnight-panels',
    title: 'Midnight Panels',
    description:
        'A thriller about a comic editor whose unreleased pages predict crimes before they happen.',
    author: 'Jun Park',
    coverImage:
        'https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=900',
    genres: const ['Mystery', 'Drama'],
    rating: 4.6,
    status: 'Ongoing',
    chapterCount: 24,
    createdAt: DateTime(2025, 11, 7),
  ),
  ComicModel(
    id: 'starlit-kitchen',
    title: 'Starlit Kitchen',
    description:
        'A comforting slice-of-life romance where every recipe opens a portal to someone else’s memory.',
    author: 'Ari Bloom',
    coverImage:
        'https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=900',
    genres: const ['Romance', 'Slice of Life'],
    rating: 4.9,
    status: 'Completed',
    chapterCount: 48,
    createdAt: DateTime(2025, 8, 4),
  ),
  ComicModel(
    id: 'iron-bloom',
    title: 'Iron Bloom',
    description:
        'When a botanist repairs abandoned mechs with living vines, a quiet desert settlement becomes the last line of defense.',
    author: 'Theo Nnamdi',
    coverImage:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900',
    genres: const ['Sci-Fi', 'Adventure'],
    rating: 4.7,
    status: 'Ongoing',
    chapterCount: 19,
    createdAt: DateTime(2026, 3, 3),
  ),
];

List<ChapterModel> mockChapters(String comicId) {
  const pages = [
    'https://images.unsplash.com/photo-1612036782180-6f0b6cd846fe?w=1400',
    'https://images.unsplash.com/photo-1608889476561-6242cfdbf622?w=1400',
    'https://images.unsplash.com/photo-1601645191163-3fc0d5d64e35?w=1400',
  ];

  return List.generate(8, (index) {
    final number = index + 1;
    return ChapterModel(
      id: '$comicId-chapter-$number',
      comicId: comicId,
      title: 'Chapter $number',
      chapterNumber: number,
      pages: pages,
      createdAt: DateTime(2026, 1, number),
    );
  });
}
