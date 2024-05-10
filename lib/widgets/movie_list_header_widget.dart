import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wework/common/app_colors.dart';

class MovieListheaderWidget extends StatelessWidget {
  const MovieListheaderWidget({super.key, required this.isNowPlayingMovieList});
  final bool isNowPlayingMovieList;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          isNowPlayingMovieList ? "NOW PLAYING" : "TOP RATED",
          style: GoogleFonts.lato(
              fontSize: 12,
              color: AppColors.locationPinColor,
              fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Container(
          height: 1,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.homePageGradientColor1.withOpacity(1),
                    AppColors.homePageGradientColor1.withOpacity(0)
                  ])),
        ))
      ],
    );
  }
}
