import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wework/bloc/moviebloc.dart';
import 'package:wework/bloc/movieevent.dart';
import 'package:wework/bloc/moviestate.dart';
import 'package:wework/common/app_colors.dart';
import 'package:wework/common/asset_strings.dart';
import 'package:wework/cubit/locationcubit.dart';
import 'package:wework/widgets/movielist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.homePageGradientColor1,
            AppColors.homePageGradientColor2
          ],
        )),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(110), // Set this height
              child: SafeArea(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<LocationCubit, List<Placemark>?>(
                        builder: (context, state) {
                          if (state != null && state.isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.locationPinColor,
                                      size: 25,
                                    ),
                                    Text(
                                      "${state.first.name}",
                                      style: GoogleFonts.lato(
                                          color: AppColors.locationPinColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "${state.first.locality}",
                                    style: GoogleFonts.lato(
                                        color: AppColors.locationPinColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: SvgPicture.asset(AssetString.cicirleLogo),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    cursorColor: AppColors.locationPinColor,
                    controller: textEditingController,
                    onChanged: (value) {
                      context.read<MovieBloc>().add(SearchMovie(value));
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      prefixIconConstraints:
                          const BoxConstraints.expand(width: 50, height: 30),
                      prefixIcon: SvgPicture.asset(AssetString.searchIcon),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      hintText: 'Seach Movies By name ...',
                    ),
                  ),
                ],
              )),
            ),
            body: RefreshIndicator(
                onRefresh: _pullRefresh,
                displacement: 150,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: const Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      MovieList(
                        isNowPlayingMovieList: true,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MovieList(
                        isNowPlayingMovieList: false,
                      ),
                    ],
                  ),
                ))));
  }

  Future<void> _pullRefresh() async {
    textEditingController.text = "";
    Future block = context.read<MovieBloc>().stream.first;
    context.read<MovieBloc>().add(Refresh());
    return block;
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    context.read<LocationCubit>().close();
    context.read<MovieBloc>().close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom &&
        textEditingController.text.isEmpty &&
        context.read<MovieBloc>().state.topRatedState.status !=
            MovieStatus.loading) {
      context.read<MovieBloc>().add(GetTopPlayed());
    }
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
