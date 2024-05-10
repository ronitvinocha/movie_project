import 'package:equatable/equatable.dart';
import 'package:wework/model/moviepage.dart';

enum MovieStatus { initial, search, success, loading, failure }

final class MovieState extends Equatable {
  const MovieState(
      {this.nowPlayingState = const MovieSubState(),
      this.topRatedState = const MovieSubState()});

  final MovieSubState nowPlayingState;
  final MovieSubState topRatedState;

  MovieState copyWith(
      {MovieStatus? status,
      List<Movie>? movies,
      bool? hasReachedMax,
      required int currentPage,
      required bool isNowPlayingMovieResult}) {
    if (isNowPlayingMovieResult) {
      return MovieState(
          topRatedState: topRatedState,
          nowPlayingState: nowPlayingState.copyWith(
              status: status,
              currentPage: currentPage,
              movies: movies,
              hasReachedMax: hasReachedMax));
    } else {
      return MovieState(
          topRatedState: topRatedState.copyWith(
              status: status,
              currentPage: currentPage,
              movies: movies,
              hasReachedMax: hasReachedMax),
          nowPlayingState: nowPlayingState);
    }
  }

  @override
  String toString() {
    return '''MovieState { nowPlayingMovies: $nowPlayingState, topratedMovies: $topRatedState}''';
  }

  @override
  List<Object> get props => [nowPlayingState, topRatedState];
}

class MovieSubState {
  const MovieSubState({
    this.status = MovieStatus.initial,
    this.movies = const <Movie>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  final MovieStatus status;
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;

  @override
  String toString() {
    return '''MovieSubState { status: $status,hasReachedMax: $hasReachedMax, movies: ${movies.length} }''';
  }

  MovieSubState copyWith({
    MovieStatus? status,
    List<Movie>? movies,
    bool? hasReachedMax,
    required int currentPage,
  }) {
    return MovieSubState(
        status: status ?? this.status,
        movies: movies ?? this.movies,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        currentPage: currentPage);
  }
}
