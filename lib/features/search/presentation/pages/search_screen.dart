import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/comic_tile.dart';
import '../bloc/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _genres = <String>{};

  @override
  Widget build(BuildContext context) {
    const genres = [
      'Action',
      'Fantasy',
      'Romance',
      'Sci-Fi',
      'Mystery',
      'Drama'
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'Search comics worldwide',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                    onPressed: _search,
                    icon: const Icon(Icons.arrow_forward_rounded)),
              ),
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final genre = genres[index];
                return FilterChip(
                  label: Text(genre),
                  selected: _genres.contains(genre),
                  onSelected: (selected) => setState(() =>
                      selected ? _genres.add(genre) : _genres.remove(genre)),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state.status == SearchStatus.initial) {
                  return const AppEmptyState(
                      title: 'Find your next series',
                      message:
                          'Try popular searches like Aurora, mystery, romance, or sci-fi.');
                }
                if (state.status == SearchStatus.loading) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (state.results.isEmpty) {
                  return const AppEmptyState(
                      title: 'No results',
                      message: 'Adjust your search or filters and try again.');
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.extentAfter < 300) {
                      context.read<SearchBloc>().add(SearchNextPageRequested());
                    }
                    return false;
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .58,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16),
                    itemCount: state.results.length,
                    itemBuilder: (_, index) =>
                        ComicTile(comic: state.results[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _search() {
    context.read<SearchBloc>().add(
        SearchRequested(query: _controller.text, genres: _genres.toList()));
  }
}
