import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wework/common/app_constnt_keys.dart';
import 'package:wework/common/utils.dart';
import 'package:wework/model/moviepage.dart';

class MovieListVerticleItem extends StatelessWidget {
  const MovieListVerticleItem({required this.movie, super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              LayoutBuilder(builder: ((context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                        imageUrl:
                            "${AppConstantString.imageBaseUrl}w${Utils.getNextMultiple(constraints.maxWidth.ceil())}${movie.backdropPath}",
                      )),
                );
              })),
              Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(5)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text((movie.voteAverage ?? 0).toStringAsFixed(2),
                            style: GoogleFonts.lato(color: Colors.white)),
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.yellowAccent,
                        )
                      ],
                    ),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 4,
                ),
                Text(
                  movie.title ?? "",
                  style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  movie.overview ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  (movie.voteCount ?? 0) / 1000 > 1
                      ? "${((movie.voteCount ?? 0) / 1000).toStringAsFixed(1)}K votes"
                      : "${(movie.voteCount ?? 0)} votes",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                      fontSize: 15,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
