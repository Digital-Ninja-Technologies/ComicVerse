part of 'search_bloc.dart';

enum SearchStatus { initial, loading, loadingMore, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.genres = const [],
    this.author,
    this.results = const [],
    this.page = 1,
    this.hasMore = false,
    this.message,
  });

  final SearchStatus status;
  final String query;
  final List<String> genres;
  final String? author;
  final List<Comic> results;
  final int page;
  final bool hasMore;
  final String? message;

  SearchState copyWith(
      {SearchStatus? status,
      List<Comic>? results,
      int? page,
      bool? hasMore,
      String? message}) {
    return SearchState(
      status: status ?? this.status,
      query: query,
      genres: genres,
      author: author,
      results: results ?? this.results,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      message: message,
    );
  }

  @override
  List<Object?> get props =>
      [status, query, genres, author, results, page, hasMore, message];
}
