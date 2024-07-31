// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  const SimpleBlocObserver();

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    print("${bloc.runtimeType}->$transition");
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print("${bloc.runtimeType}->$change");
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}
