import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:wework/bloc/movieevent.dart';
import 'package:wework/bloc/moviestate.dart';
import 'package:wework/common/utils.dart';
import 'package:wework/model/moviepage.dart';
import 'package:wework/repository/movierepository.dart';

const throttleDuration = Duration(milliseconds: 100);
const searchThrottleDuration = Duration(milliseconds: 300);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

EventTransformer<E> searchThrottleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(searchThrottleDuration), mapper);
  };
}

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  var unFilteredNowPlayingMovies = <Movie>[];
  var unFilteredTopRatedMovies = <Movie>[];
  MovieBloc({required this.movieRepository}) : super(const MovieState()) {
    on<GetNowPlaying>(
      _getMovies,
      transformer: throttleDroppable(throttleDuration),
    );
    on<GetTopPlayed>(
      _getMovies,
      transformer: throttleDroppable(throttleDuration),
    );
    on<SearchMovie>(
      _searchMovie,
      transformer: searchThrottleDroppable(searchThrottleDuration),
    );
    on<Refresh>(
      _refresh,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final MovieRepository movieRepository;

  Future<void> _getMovies(
    MovieEvent event,
    Emitter<MovieState> emit,
  ) async {
    var isGetNowPlayingEvent = event is GetNowPlaying;
    var requestedMovieSubState = state.nowPlayingState;
    if (isGetNowPlayingEvent) {
      requestedMovieSubState = state.nowPlayingState;
    } else {
      requestedMovieSubState = state.topRatedState;
    }
    if (requestedMovieSubState.hasReachedMax) return;
    try {
      if (requestedMovieSubState.status == MovieStatus.initial) {
        final nowPlayingMoviePage = await movieRepository.getMovies();
        emit(
          state.copyWith(
              status: MovieStatus.success,
              movies: nowPlayingMoviePage.results,
              hasReachedMax: false,
              currentPage: state.nowPlayingState.currentPage,
              isNowPlayingMovieResult: true),
        );

        final topRatedMoviePage =
            await movieRepository.getMovies(isNowPlayingMovieRequest: false);

        emit(
          state.copyWith(
              status: MovieStatus.success,
              movies: topRatedMoviePage.results,
              hasReachedMax: false,
              currentPage: state.topRatedState.currentPage,
              isNowPlayingMovieResult: false),
        );
      } else {
        final moviePage = await movieRepository.getMovies(
            page: requestedMovieSubState.currentPage + 1,
            isNowPlayingMovieRequest: isGetNowPlayingEvent);
        moviePage.results.isEmpty
            ? emit(state.copyWith(
                hasReachedMax: true,
                currentPage: requestedMovieSubState.currentPage + 1,
                isNowPlayingMovieResult: isGetNowPlayingEvent))
            : emit(
                state.copyWith(
                    status: MovieStatus.success,
                    movies: List.of(requestedMovieSubState.movies)
                      ..addAll(moviePage.results),
                    hasReachedMax: false,
                    currentPage: requestedMovieSubState.currentPage + 1,
                    isNowPlayingMovieResult: isGetNowPlayingEvent),
              );
      }
      unFilteredNowPlayingMovies = state.nowPlayingState.movies;
      unFilteredTopRatedMovies = state.topRatedState.movies;
    } catch (e, st) {
      Utils.printLog(runtimeType.toString(), e.toString());
      Utils.printLog(runtimeType.toString(), st.toString());
      emit(state.copyWith(
          status: MovieStatus.failure,
          currentPage: requestedMovieSubState.currentPage,
          isNowPlayingMovieResult: isGetNowPlayingEvent));
    }
  }

  _searchMovie(
    SearchMovie event,
    Emitter<MovieState> emit,
  ) {
    emit(
      state.copyWith(
          status: event.searchText.isEmpty
              ? MovieStatus.success
              : MovieStatus.search,
          movies:
              _searchMovieInList(unFilteredNowPlayingMovies, event.searchText),
          hasReachedMax: false,
          currentPage: state.nowPlayingState.currentPage,
          isNowPlayingMovieResult: true),
    );
    emit(
      state.copyWith(
          status: event.searchText.isEmpty
              ? MovieStatus.success
              : MovieStatus.search,
          movies:
              _searchMovieInList(unFilteredTopRatedMovies, event.searchText),
          currentPage: state.nowPlayingState.currentPage,
          isNowPlayingMovieResult: false),
    );
  }

  _refresh(
    MovieEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(
      state.copyWith(
          status: MovieStatus.loading,
          currentPage: 1,
          isNowPlayingMovieResult: true),
    );

    emit(
      state.copyWith(
          status: MovieStatus.loading,
          currentPage: 1,
          isNowPlayingMovieResult: false),
    );
    final nowPlayingMoviePage = await movieRepository.getMovies(refresh: true);
    emit(
      state.copyWith(
          status: MovieStatus.success,
          movies: nowPlayingMoviePage.results,
          hasReachedMax: false,
          currentPage: 1,
          isNowPlayingMovieResult: true),
    );

    final topRatedMoviePage = await movieRepository.getMovies(
        isNowPlayingMovieRequest: false, refresh: true);

    emit(
      state.copyWith(
          status: MovieStatus.success,
          movies: topRatedMoviePage.results,
          hasReachedMax: false,
          currentPage: 1,
          isNowPlayingMovieResult: false),
    );
  }

  List<Movie> _searchMovieInList(List<Movie> movies, String searchText) {
    if (searchText.isEmpty) {
      return movies;
    } else {
      return movies
          .where((i) => (i.title ?? "")
              .toUpperCase()
              .startsWith(searchText.toUpperCase()))
          .toList();
    }
  }
}
