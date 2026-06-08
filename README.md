# ComicVerse

ComicVerse is a Flutter comic reader built with Clean Architecture, BLoC, GoRouter, Hive, Dio, Cached Network Image, secure storage, and Firebase services.

## What Is Included

- Firebase Authentication with email/password, Google sign-in, password reset, and guest login.
- Firestore-backed user profiles, favorites, and reading metadata.
- Home, search, comic details, reader, downloads, favorites, profile, and settings screens.
- Hive boxes for offline catalog cache, chapters, downloads, reading progress, and recent searches.
- Download manager for chapter pages with progress, pause, and delete support.
- Vertical and horizontal reader modes with pinch zoom, night mode, and reading progress autosave.
- Light and dark Material 3 theme.

## Setup

1. Install Flutter stable and Firebase CLI.
2. From this folder, fetch dependencies:

   ```sh
   flutter pub get
   ```

3. Configure Firebase:

   ```sh
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

4. Ensure Firebase products are enabled:

   - Authentication: Email/password, Google, Anonymous
   - Firestore Database
   - Firebase Storage
   - Firebase Cloud Messaging
   - Analytics

5. Run the app:

   ```sh
   flutter run
   ```

## Firestore Collections

- `users/{userId}` stores `id`, `name`, `email`, `avatar`, `favorites`, `readingHistory`, `createdAt`, and `isGuest`.
- `comics/{comicId}` can mirror the `Comic` model.
- `comics/{comicId}/chapters/{chapterId}` can mirror the `Chapter` model.
- Download file records are kept locally in Hive; uploaded canonical comic pages should live in Firebase Storage or your comic API.

## Firestore Rules

Start with `firestore.rules` in this folder. Tighten comic write permissions for your admin publishing flow before production release.

## Notes

The repository ships with a small offline mock catalog so the UI can be exercised before a production API is connected. Replace `ComicRepositoryImpl._catalog` with real API or Firestore reads when content ingestion is ready.
