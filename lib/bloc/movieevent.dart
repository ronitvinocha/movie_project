import 'package:equatable/equatable.dart';

sealed class MovieEvent extends Equatable {
  @override
  List<Object> get props => [];
  const MovieEvent();
}

final class GetNowPlaying extends MovieEvent {}

final class GetTopPlayed extends MovieEvent {}

final class SearchMovie extends MovieEvent {
  const SearchMovie(this.searchText);
  final String searchText;
}

final class Refresh extends MovieEvent {}
