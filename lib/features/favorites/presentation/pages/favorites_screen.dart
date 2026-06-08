import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/comic_tile.dart';
import '../../../../data/repositories/comic_repository_impl.dart';
import '../bloc/favorites_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, favorites) {
          if (favorites.ids.isEmpty) {
            return const AppEmptyState(
                title: 'No favorites',
                message: 'Tap the heart on comic details to save series here.',
                icon: Icons.favorite_border_rounded);
          }
          return FutureBuilder(
            future: Future.wait(favorites.ids
                .map((id) => context.read<ComicRepositoryImpl>().comic(id))),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .58,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) =>
                    ComicTile(comic: snapshot.data![index]),
              );
            },
          );
        },
      ),
    );
  }
}
