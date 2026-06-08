import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/app_services.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/comic_repository_impl.dart';
import 'data/repositories/download_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/downloads/presentation/bloc/downloads_bloc.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/reader/presentation/bloc/reader_bloc.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final services = await AppServices.bootstrap();

  final comicRepository = ComicRepositoryImpl(
    api: services.api,
    localStore: services.localStore,
  );
  final userRepository = UserRepositoryImpl(
    auth: services.auth,
    firestore: services.firestore,
    secureStorage: services.secureStorage,
    googleSignIn: services.googleSignIn,
  );
  final downloadRepository = DownloadRepositoryImpl(
    dio: services.api.client,
    localStore: services.localStore,
    downloadManager: services.downloadManager,
  );

  runApp(
    ComicVerseApp(
      comicRepository: comicRepository,
      userRepository: userRepository,
      downloadRepository: downloadRepository,
    ),
  );
}

class ComicVerseApp extends StatelessWidget {
  const ComicVerseApp({
    required this.comicRepository,
    required this.userRepository,
    required this.downloadRepository,
    super.key,
  });

  final ComicRepositoryImpl comicRepository;
  final UserRepositoryImpl userRepository;
  final DownloadRepositoryImpl downloadRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: comicRepository),
        RepositoryProvider.value(value: userRepository),
        RepositoryProvider.value(value: downloadRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => AuthBloc(userRepository)..add(AuthStarted())),
          BlocProvider(
              create: (_) => HomeBloc(comicRepository)..add(HomeRequested())),
          BlocProvider(create: (_) => SearchBloc(comicRepository)),
          BlocProvider(create: (_) => ReaderBloc(comicRepository)),
          BlocProvider(
              create: (_) =>
                  DownloadsBloc(downloadRepository)..add(DownloadsLoaded())),
          BlocProvider(
              create: (_) =>
                  FavoritesBloc(userRepository)..add(FavoritesLoaded())),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return MaterialApp.router(
              title: 'ComicVerse',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: ThemeMode.system,
              routerConfig: AppRouter.router(authState),
            );
          },
        ),
      ),
    );
  }
}
