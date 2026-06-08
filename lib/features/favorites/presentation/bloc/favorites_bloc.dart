import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/user_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this._repository) : super(const FavoritesState()) {
    on<FavoritesLoaded>(_onLoaded);
    on<FavoriteToggled>(_onToggled);
  }

  final UserRepository _repository;

  Future<void> _onLoaded(
      FavoritesLoaded event, Emitter<FavoritesState> emit) async {
    final ids = await _repository.favoriteIds();
    emit(FavoritesState(ids: ids));
  }

  Future<void> _onToggled(
      FavoriteToggled event, Emitter<FavoritesState> emit) async {
    await _repository.toggleFavorite(event.comicId);
    add(FavoritesLoaded());
  }
}
