import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/widgets/comic_cover.dart';
import '../../../../data/repositories/comic_repository_impl.dart';
import '../../../../domain/entities/chapter.dart';
import '../../../../domain/entities/comic.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../downloads/presentation/bloc/downloads_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';

class ComicDetailsScreen extends StatelessWidget {
  const ComicDetailsScreen({required this.comicId, super.key});

  final String comicId;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<ComicRepositoryImpl>();
    return Scaffold(
      body: FutureBuilder<(Comic, List<Chapter>)>(
        future: Future.wait(
                [repository.comic(comicId), repository.chapters(comicId)])
            .then((items) => (items[0] as Comic, items[1] as List<Chapter>)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final comic = snapshot.data!.$1;
          final chapters = snapshot.data!.$2;
          final firstChapter = chapters.first;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 330,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      ComicCover(imageUrl: comic.coverImage, borderRadius: 0),
                      DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: .48))),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ComicCover(
                                  imageUrl: comic.coverImage,
                                  width: 112,
                                  height: 156),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(comic.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900)),
                                    Text('${comic.author} • ${comic.status}',
                                        style: const TextStyle(
                                            color: Colors.white70)),
                                    Text(
                                        '${comic.rating} rating • ${comic.chapterCount} chapters',
                                        style: const TextStyle(
                                            color: Colors.white70)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                          spacing: 8,
                          children: comic.genres
                              .map((genre) => Chip(label: Text(genre)))
                              .toList()),
                      const SizedBox(height: 12),
                      Text(comic.description),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: FilledButton.icon(
                                  onPressed: () => context.push(
                                      '/reader/${comic.id}/${firstChapter.id}'),
                                  icon: const Icon(Icons.menu_book_rounded),
                                  label: const Text('Read Now'))),
                          const SizedBox(width: 8),
                          IconButton.filledTonal(
                              onPressed: () => context
                                  .read<FavoritesBloc>()
                                  .add(FavoriteToggled(comic.id)),
                              icon: BlocBuilder<FavoritesBloc, FavoritesState>(
                                  builder: (_, state) => Icon(
                                      state.contains(comic.id)
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded))),
                          IconButton.filledTonal(
                              onPressed: () => Share.share(
                                  'Read ${comic.title} on ComicVerse'),
                              icon: const Icon(Icons.ios_share_rounded)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          final user = context.read<AuthBloc>().state.user;
                          if (user != null) {
                            context.read<DownloadsBloc>().add(
                                DownloadChapterRequested(
                                    userId: user.id,
                                    comicId: comic.id,
                                    chapter: firstChapter));
                          }
                        },
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Download first chapter'),
                      ),
                      const SizedBox(height: 16),
                      Text('Chapters',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
              SliverList.separated(
                itemCount: chapters.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  return ListTile(
                    title: Text(chapter.title),
                    subtitle: Text('Chapter ${chapter.chapterNumber}'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () =>
                        context.push('/reader/${comic.id}/${chapter.id}'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
