import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wework/bloc/movieevent.dart';
import 'package:wework/model/moviepage.dart';
import 'package:wework/widgets/emptymovielist.dart';
import 'package:wework/widgets/movie_list_header_widget.dart';
import 'package:wework/widgets/movieitesmwidgethorizontal.dart';

import '../bloc/moviebloc.dart';

class MovieHorizontalList extends StatelessWidget {
  const MovieHorizontalList(
      {super.key, required this.movies, required this.hasReachedMax});
  final List<Movie> movies;
  final bool hasReachedMax;
  @override
  Widget build(BuildContext context) {
    // print("build called ${context.read<MovieBloc>().state}");
    return movies.isEmpty
        ? const EmptyMovieListWidget()
        : Column(children: [
            const MovieListheaderWidget(isNowPlayingMovieList: true),
            const SizedBox(
              height: 10,
            ),
            CarouselSlider.builder(
                itemCount: movies.length,
                itemBuilder: (context, index, realIndex) {
                  return MovieListHorizontalItem(movie: movies[index]);
                },
                options: CarouselOptions(
                  height: 350,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  disableCenter: true,
                  autoPlay: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  onPageChanged: (index, reason) {
                    if (index >= movies.length - 3 && !hasReachedMax) {
                      context.read<MovieBloc>().add(GetNowPlaying());
                    }
                  },
                  scrollDirection: Axis.horizontal,
                ))
          ]);
  }
}
