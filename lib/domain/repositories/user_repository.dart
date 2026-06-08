import '../entities/app_user.dart';

abstract class UserRepository {
  Stream<AppUser?> authState();
  Future<AppUser> login(String email, String password);
  Future<AppUser> register(String name, String email, String password);
  Future<void> forgotPassword(String email);
  Future<AppUser> loginWithGoogle();
  Future<AppUser> loginAsGuest();
  Future<void> logout();
  Future<List<String>> favoriteIds();
  Future<void> toggleFavorite(String comicId);
}
