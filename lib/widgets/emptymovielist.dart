import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wework/common/app_colors.dart';

class EmptyMovieListWidget extends StatelessWidget {
  const EmptyMovieListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Text(
        "No movie found",
        style: GoogleFonts.lato(
            color: AppColors.locationPinColor,
            fontSize: 14,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
