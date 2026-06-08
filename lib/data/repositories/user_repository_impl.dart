import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/app_user_model.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required this.auth,
    required this.firestore,
    required this.secureStorage,
    required this.googleSignIn,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FlutterSecureStorage secureStorage;
  final GoogleSignIn googleSignIn;

  CollectionReference<Map<String, dynamic>> get _users =>
      firestore.collection('users');

  @override
  Stream<AppUser?> authState() {
    return auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return _loadOrCreate(firebaseUser, isGuest: firebaseUser.isAnonymous);
    });
  }

  @override
  Future<AppUser> login(String email, String password) async {
    final credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    await secureStorage.write(key: 'last_login_email', value: email);
    return _loadOrCreate(credential.user!);
  }

  @override
  Future<AppUser> register(String name, String email, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await credential.user!.updateDisplayName(name);
    return _loadOrCreate(credential.user!, name: name);
  }

  @override
  Future<void> forgotPassword(String email) =>
      auth.sendPasswordResetEmail(email: email);

  @override
  Future<AppUser> loginWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw StateError('Google sign-in cancelled');
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await auth.signInWithCredential(credential);
    return _loadOrCreate(userCredential.user!);
  }

  @override
  Future<AppUser> loginAsGuest() async {
    final credential = await auth.signInAnonymously();
    return _loadOrCreate(credential.user!, name: 'Guest Reader', isGuest: true);
  }

  @override
  Future<void> logout() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }

  @override
  Future<List<String>> favoriteIds() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      return [];
    }
    final doc = await _users.doc(uid).get();
    return List<String>.from(doc.data()?['favorites'] as List? ?? const []);
  }

  @override
  Future<void> toggleFavorite(String comicId) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      return;
    }
    final favorites = await favoriteIds();
    final next = favorites.contains(comicId)
        ? favorites.where((id) => id != comicId).toList()
        : [...favorites, comicId];
    await _users.doc(uid).set({'favorites': next}, SetOptions(merge: true));
  }

  Future<AppUserModel> _loadOrCreate(
    User firebaseUser, {
    String? name,
    bool isGuest = false,
  }) async {
    final doc = await _users.doc(firebaseUser.uid).get();
    if (doc.exists && doc.data() != null) {
      return AppUserModel.fromJson({'id': firebaseUser.uid, ...doc.data()!});
    }

    final user = AppUserModel(
      id: firebaseUser.uid,
      name: name ?? firebaseUser.displayName ?? 'Reader',
      email: firebaseUser.email ?? '',
      avatar: firebaseUser.photoURL ?? '',
      favorites: const [],
      readingHistory: const {},
      createdAt: DateTime.now(),
      isGuest: isGuest,
    );
    await _users.doc(firebaseUser.uid).set(user.toJson());
    return user;
  }
}
