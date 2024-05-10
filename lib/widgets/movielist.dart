import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wework/bloc/moviebloc.dart';
import 'package:wework/bloc/moviestate.dart';
import 'package:wework/common/app_colors.dart';
import 'package:wework/widgets/movielisthorizontal.dart';
import 'package:wework/widgets/movielistvertical.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key, required this.isNowPlayingMovieList});

  final bool isNowPlayingMovieList;

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
  }

  MovieSubState isNowPlayingMovieList(MovieState state) {
    if (widget.isNowPlayingMovieList) {
      return state.nowPlayingState;
    } else {
      return state.topRatedState;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSelector<MovieBloc, MovieState, MovieSubState>(
          selector: isNowPlayingMovieList,
          builder: (context, state) {
            switch (state.status) {
              case MovieStatus.failure:
                return const Center(child: Text('failed to fetch posts'));
              case MovieStatus.loading:
                return widget.isNowPlayingMovieList
                    ? Container(
                        margin: const EdgeInsets.only(top: 60),
                        child: const CircularProgressIndicator(
                          color: AppColors.homePageGradientColor1,
                        ),
                      )
                    : Container();
              case MovieStatus.success:
                return widget.isNowPlayingMovieList
                    ? MovieHorizontalList(
                        movies: state.movies,
                        hasReachedMax: state.hasReachedMax)
                    : MovieListVertical(
                        movies: state.movies,
                        hasReachedMax: state.hasReachedMax);
              case MovieStatus.search:
                return widget.isNowPlayingMovieList
                    ? MovieHorizontalList(
                        movies: state.movies, hasReachedMax: true)
                    : MovieListVertical(
                        movies: state.movies, hasReachedMax: true);
              case MovieStatus.initial:
                return const Center(child: CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }
}
