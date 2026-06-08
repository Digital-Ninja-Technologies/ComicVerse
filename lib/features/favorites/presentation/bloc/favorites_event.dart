part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object?> get props => [];
}

class FavoritesLoaded extends FavoritesEvent {}

class FavoriteToggled extends FavoritesEvent {
  const FavoriteToggled(this.comicId);
  final String comicId;
  @override
  List<Object?> get props => [comicId];
}
