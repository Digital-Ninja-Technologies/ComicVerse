part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.featured = const [],
    this.trending = const [],
    this.popular = const [],
    this.newReleases = const [],
    this.continueReading = const [],
    this.message,
  });

  final HomeStatus status;
  final List<Comic> featured;
  final List<Comic> trending;
  final List<Comic> popular;
  final List<Comic> newReleases;
  final List<Comic> continueReading;
  final String? message;

  HomeState copyWith({HomeStatus? status, String? message}) {
    return HomeState(
      status: status ?? this.status,
      featured: featured,
      trending: trending,
      popular: popular,
      newReleases: newReleases,
      continueReading: continueReading,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        featured,
        trending,
        popular,
        newReleases,
        continueReading,
        message
      ];
}
