part of 'downloads_bloc.dart';

enum DownloadsStatus { initial, loading, success, failure }

class DownloadsState extends Equatable {
  const DownloadsState(
      {this.status = DownloadsStatus.initial,
      this.items = const [],
      this.message});

  final DownloadsStatus status;
  final List<DownloadItem> items;
  final String? message;

  DownloadsState copyWith(
      {DownloadsStatus? status, List<DownloadItem>? items, String? message}) {
    return DownloadsState(
        status: status ?? this.status,
        items: items ?? this.items,
        message: message);
  }

  @override
  List<Object?> get props => [status, items, message];
}
