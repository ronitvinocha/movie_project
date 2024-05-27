import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wework/bloc/moviebloc.dart';
import 'package:wework/bloc/moviestate.dart';
import 'package:wework/cubit/locationcubit.dart';

class LoaderPage extends StatefulWidget {
  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  var durationInSeconds = 2;
  var pausePoint = 0.0;
  StreamSubscription<List<Placemark>?>? locationCubitSubscription;
  StreamSubscription<MovieState>? movieBlocSubscription;

  @override
  void initState() {
    startAnimation();
    super.initState();
  }

  startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.popAndPushNamed(context, "/home");
        }
      });
    _animation = CurveTween(curve: Curves.decelerate).animate(_controller);
    _controller.forward();
  }

  double _checkAnimationValue(double animationValue) {
    if (animationValue * 100 < 30) {
      return animationValue;
    } else if (30 <= animationValue * 100 && animationValue * 100 < 60) {
      if (context.read<LocationCubit>().state != null &&
          (context.read<LocationCubit>().state ?? []).isNotEmpty) {
        return animationValue;
      } else {
        _controller.stop();
        pausePoint = 30 / 100;
        addLocationCubitListner();
        return pausePoint;
      }
    } else {
      if (context.read<MovieBloc>().state.nowPlayingState.status !=
          MovieStatus.initial) {
        return animationValue;
      } else {
        _controller.stop();
        pausePoint = 60 / 100;
        addMovieBlocListner();
        return pausePoint;
      }
    }
  }

  addLocationCubitListner() {
    locationCubitSubscription =
        context.watch<LocationCubit>().stream.listen((state) {
      if (state != null && state.isNotEmpty) {
        _controller.forward(from: pausePoint);
      }
    });
  }

  addMovieBlocListner() {
    movieBlocSubscription = context.watch<MovieBloc>().stream.listen((state) {
      if (state.nowPlayingState.status == MovieStatus.success) {
        _controller.forward(from: pausePoint);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    locationCubitSubscription?.cancel();
    movieBlocSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            BlocBuilder<LocationCubit, List<Placemark>?>(
                builder: (context, state) {
              if (state != null && state.isEmpty) {
                return Text(
                  "Need location to get movies played near you\n Please provide in setting",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.w600),
                );
              } else {
                return Stack(
                  children: [
                    AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              value: _checkAnimationValue(_controller.value),
                              color: Colors.black,
                              semanticsLabel: 'Circular progress indicator',
                            ),
                          );
                        }),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        "assets/images/logo.svg",
                        width: 25,
                        height: 25,
                      ),
                    )
                  ],
                );
              }
            })
          ])),
    ));
  }
}
