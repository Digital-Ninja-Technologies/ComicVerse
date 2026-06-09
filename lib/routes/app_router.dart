import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/forgot_password_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart';
import '../features/comic_details/presentation/pages/comic_details_screen.dart';
import '../features/downloads/presentation/pages/downloads_screen.dart';
import '../features/favorites/presentation/pages/favorites_screen.dart';
import '../features/home/presentation/pages/home_screen.dart';
import '../features/profile/presentation/pages/profile_screen.dart';
import '../features/reader/presentation/pages/reader_screen.dart';
import '../features/search/presentation/pages/search_screen.dart';
import '../features/settings/presentation/pages/settings_screen.dart';

// ---------------------------------------------------------------------------
// Shell scaffold — persistent bottom nav bar
// ---------------------------------------------------------------------------

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search_rounded),
      label: 'Search',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_border_rounded),
      selectedIcon: Icon(Icons.favorite_rounded),
      label: 'Favourites',
    ),
    NavigationDestination(
      icon: Icon(Icons.download_outlined),
      selectedIcon: Icon(Icons.download_rounded),
      label: 'Downloads',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: _destinations,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Router factory
// ---------------------------------------------------------------------------

class AppRouter {
  const AppRouter._();

  static GoRouter router(AuthState authState) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final status = authState.status;
        final loc = state.matchedLocation;

        final isUnknown = status == AuthStatus.unknown;
        final isAuthed = status == AuthStatus.authenticated;
        final isOnAuth = loc == '/login' ||
            loc == '/register' ||
            loc == '/forgot-password';

        if (isUnknown) return null; // splash / wait
        if (!isAuthed && !isOnAuth) return '/login';
        if (isAuthed && isOnAuth) return '/';
        return null;
      },
      routes: [
        // ------------------------------------------------------------------
        // Auth routes (no shell)
        // ------------------------------------------------------------------
        GoRoute(
          path: '/login',
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (_, __) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (_, __) => const ForgotPasswordScreen(),
        ),

        // ------------------------------------------------------------------
        // Detail / reader routes (no shell, pushed on top)
        // ------------------------------------------------------------------
        GoRoute(
          path: '/comic/:comicId',
          builder: (_, state) => ComicDetailsScreen(
            comicId: state.pathParameters['comicId']!,
          ),
        ),
        GoRoute(
          path: '/reader/:comicId/:chapterId',
          builder: (_, state) => ReaderScreen(
            comicId: state.pathParameters['comicId']!,
            chapterId: state.pathParameters['chapterId']!,
          ),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const SettingsScreen(),
        ),

        // ------------------------------------------------------------------
        // Shell (bottom nav)
        // ------------------------------------------------------------------
        StatefulShellRoute.indexedStack(
          builder: (_, __, navigationShell) =>
              _AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/search',
                  builder: (_, __) => const SearchScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/favorites',
                  builder: (_, __) => const FavoritesScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/downloads',
                  builder: (_, __) => const DownloadsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (_, __) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
