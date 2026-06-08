import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/comic_cover.dart';
import '../../../../core/widgets/comic_tile.dart';
import '../../../../core/widgets/section_header.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ComicVerse'), actions: [
        IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined))
      ]),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading ||
              state.status == HomeStatus.initial) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state.status == HomeStatus.failure) {
            return AppErrorState(
                message: state.message ?? 'Could not load comics',
                onRetry: () => context.read<HomeBloc>().add(HomeRequested()));
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<HomeBloc>().add(HomeRequested()),
            child: ListView(
              children: [
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: .88),
                    itemCount: state.featured.length,
                    itemBuilder: (context, index) {
                      final comic = state.featured[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => context.push('/comic/${comic.id}'),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ComicCover(
                                  imageUrl: comic.coverImage, borderRadius: 8),
                              DecoratedBox(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black87
                                          ]))),
                              Positioned(
                                left: 20,
                                right: 20,
                                bottom: 18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(comic.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900)),
                                    Text(
                                        '${comic.rating} • ${comic.genres.join(', ')}',
                                        style: const TextStyle(
                                            color: Colors.white70)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _Rail(title: 'Continue Reading', comics: state.continueReading),
                _Rail(title: 'Trending Comics', comics: state.trending),
                _Rail(title: 'Popular Comics', comics: state.popular),
                _Rail(title: 'New Releases', comics: state.newReleases),
                const SectionHeader(title: 'Categories'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Action',
                      'Fantasy',
                      'Romance',
                      'Sci-Fi',
                      'Mystery',
                      'Slice of Life'
                    ]
                        .map((genre) => ActionChip(
                            label: Text(genre),
                            onPressed: () => context.go('/search')))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.title, required this.comics});

  final String title;
  final List comics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        SizedBox(
          height: 232,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: comics.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) =>
                ComicTile(comic: comics[index], compact: true),
          ),
        ),
      ],
    );
  }
}
