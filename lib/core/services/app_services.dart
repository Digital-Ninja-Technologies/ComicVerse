import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'api_service.dart';
import 'download_manager.dart';
import 'local_store.dart';

class AppServices {
  const AppServices({
    required this.api,
    required this.localStore,
    required this.downloadManager,
    required this.auth,
    required this.firestore,
    required this.secureStorage,
    required this.googleSignIn,
  });

  final ApiService api;
  final LocalStore localStore;
  final DownloadManager downloadManager;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FlutterSecureStorage secureStorage;
  final GoogleSignIn googleSignIn;

  static Future<AppServices> bootstrap() async {
    return AppServices(
      api: ApiService(),
      localStore: await LocalStore.initialize(),
      downloadManager: DownloadManager(),
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      secureStorage: const FlutterSecureStorage(),
      googleSignIn: GoogleSignIn(),
    );
  }
}
