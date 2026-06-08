import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../domain/entities/download_item.dart';
import '../bloc/downloads_bloc.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: BlocBuilder<DownloadsBloc, DownloadsState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const AppEmptyState(
                title: 'No downloads yet',
                message:
                    'Download chapters from comic details to read offline.',
                icon: Icons.download_outlined);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Card(
                child: ListTile(
                  leading: Icon(item.downloadStatus == DownloadStatus.completed
                      ? Icons.check_circle_rounded
                      : Icons.downloading_rounded),
                  title: Text(item.chapterId),
                  subtitle: LinearProgressIndicator(value: item.progress),
                  trailing: Wrap(
                    children: [
                      IconButton(
                          onPressed: () => context
                              .read<DownloadsBloc>()
                              .add(DownloadPauseRequested(item.id)),
                          icon: const Icon(Icons.pause_rounded)),
                      IconButton(
                          onPressed: () => context
                              .read<DownloadsBloc>()
                              .add(DownloadDeleteRequested(item.id)),
                          icon: const Icon(Icons.delete_outline_rounded)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
