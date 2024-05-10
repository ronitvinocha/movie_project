import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wework/common/app_constnt_keys.dart';
import 'package:wework/bloc/moviebloc.dart';
import 'package:wework/bloc/movieevent.dart';
import 'package:wework/cubit/locationcubit.dart';
import 'package:wework/model/moviepage.dart';
import 'package:wework/pages/homepage.dart';
import 'package:wework/pages/loaderpage.dart';
import 'package:wework/repository/movierepository.dart';
import 'package:wework/simpleblocobserver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const SimpleBlocObserver();
  await Hive.initFlutter();
  await openHiveBox();
  runApp(const MainApp());
}

openHiveBox() async {
  Hive.registerAdapter(MoviePageAdapter());
  Hive.registerAdapter(MovieAdapter());
  Hive.registerAdapter(DatesAdapter());
  await Hive.openBox<MoviePage>(AppConstantString.nowPlayingPages);
  await Hive.openBox<MoviePage>(AppConstantString.topCategoriesPages);
}

PageRoute getPageRoute({
  required Widget child,
  required RouteSettings settings,
}) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(builder: (_) => child, settings: settings);
  } else {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              lazy: false,
              create: ((context) => LocationCubit()..determineLocation())),
          BlocProvider(
            lazy: false,
            create: (context) => MovieBloc(movieRepository: MovieRepository())
              ..add(GetNowPlaying()),
          )
        ],
        child: MaterialApp(
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/':
                return getPageRoute(
                    child: const LoaderPage(), settings: settings);
              case '/home':
                return getPageRoute(
                    child: const HomePage(), settings: settings);
            }
            return null;
          },
        ));
  }
}
