import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.avatar,
    required super.favorites,
    required super.readingHistory,
    required super.createdAt,
    super.isGuest,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Reader',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      favorites: List<String>.from(json['favorites'] as List? ?? const []),
      readingHistory:
          Map<String, int>.from(json['readingHistory'] as Map? ?? const {}),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      isGuest: json['isGuest'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar': avatar,
        'favorites': favorites,
        'readingHistory': readingHistory,
        'createdAt': createdAt.toIso8601String(),
        'isGuest': isGuest,
      };
}
