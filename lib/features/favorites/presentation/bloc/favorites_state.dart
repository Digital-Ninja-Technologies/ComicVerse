part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  const FavoritesState({this.ids = const []});

  final List<String> ids;

  bool contains(String comicId) => ids.contains(comicId);

  @override
  List<Object?> get props => [ids];
}
