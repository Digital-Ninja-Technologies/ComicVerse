import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.favorites,
    required this.readingHistory,
    required this.createdAt,
    this.isGuest = false,
  });

  final String id;
  final String name;
  final String email;
  final String avatar;
  final List<String> favorites;
  final Map<String, int> readingHistory;
  final DateTime createdAt;
  final bool isGuest;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    List<String>? favorites,
    Map<String, int>? readingHistory,
    DateTime? createdAt,
    bool? isGuest,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      favorites: favorites ?? this.favorites,
      readingHistory: readingHistory ?? this.readingHistory,
      createdAt: createdAt ?? this.createdAt,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, email, avatar, favorites, readingHistory, createdAt, isGuest];
}
