part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchRequested extends SearchEvent {
  const SearchRequested(
      {required this.query, this.genres = const [], this.author});
  final String query;
  final List<String> genres;
  final String? author;
  @override
  List<Object?> get props => [query, genres, author];
}

class SearchNextPageRequested extends SearchEvent {}
