import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wework/common/app_colors.dart';
import 'package:wework/model/moviepage.dart';
import 'package:wework/widgets/listloadingwidget.dart';
import 'package:wework/widgets/movie_list_header_widget.dart';
import 'package:wework/widgets/movieitemwidgetverticle.dart';

class MovieListVertical extends StatelessWidget {
  const MovieListVertical(
      {super.key, required this.movies, required this.hasReachedMax});
  final List<Movie> movies;
  final bool hasReachedMax;
  @override
  Widget build(BuildContext context) {
    return movies.isEmpty
        ? SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Text(
              "No movie found",
              style: GoogleFonts.lato(
                  color: AppColors.locationPinColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ))
        : Column(
            children: [
              const MovieListheaderWidget(isNowPlayingMovieList: false),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return index >= movies.length
                      ? const BottomLoader()
                      : MovieListVerticleItem(movie: movies[index]);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemCount: hasReachedMax ? movies.length : movies.length + 1,
              )
            ],
          );
  }
}
