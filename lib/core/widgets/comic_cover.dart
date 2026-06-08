import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ComicCover extends StatelessWidget {
  const ComicCover({
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 8,
    super.key,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, __) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator.adaptive()),
        ),
        errorWidget: (_, __, ___) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }
}
