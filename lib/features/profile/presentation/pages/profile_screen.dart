import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../downloads/presentation/bloc/downloads_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    final downloads = context.watch<DownloadsBloc>().state.items.length;
    final favorites = context.watch<FavoritesBloc>().state.ids.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 36,
                  backgroundImage: user?.avatar.isNotEmpty == true
                      ? NetworkImage(user!.avatar)
                      : null,
                  child: user?.avatar.isEmpty != false
                      ? const Icon(Icons.person_rounded, size: 34)
                      : null),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? 'Reader',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    Text(user?.email.isNotEmpty == true
                        ? user!.email
                        : 'Guest session'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _Metric(
                  label: 'History',
                  value: '${user?.readingHistory.length ?? 0}'),
              _Metric(label: 'Downloads', value: '$downloads'),
              _Metric(label: 'Favorites', value: '$favorites'),
            ],
          ),
          const SizedBox(height: 24),
          const ListTile(
              leading: Icon(Icons.history_rounded),
              title: Text('Reading history'),
              subtitle: Text('Recently opened chapters and saved positions')),
          const ListTile(
              leading: Icon(Icons.cloud_sync_outlined),
              title: Text('Cloud sync'),
              subtitle: Text('Favorites and history sync through Firestore')),
          const SizedBox(height: 16),
          OutlinedButton.icon(
              onPressed: () =>
                  context.read<AuthBloc>().add(AuthLogoutRequested()),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log out')),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w900)),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
