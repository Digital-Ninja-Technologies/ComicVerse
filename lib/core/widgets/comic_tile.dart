import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/comic.dart';
import 'comic_cover.dart';

class ComicTile extends StatelessWidget {
  const ComicTile({required this.comic, this.compact = false, super.key});

  final Comic comic;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.push('/comic/${comic.id}'),
      child: SizedBox(
        width: compact ? 118 : 148,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ComicCover(
                imageUrl: comic.coverImage,
                height: compact ? 158 : 198,
                width: double.infinity),
            const SizedBox(height: 8),
            Text(comic.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 2),
            Text(comic.genres.take(2).join(' • '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
