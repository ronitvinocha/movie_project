import 'package:hive/hive.dart';
import 'package:wework/common/app_constnt_keys.dart';
import 'package:wework/common/utils.dart';
import 'package:wework/model/moviepage.dart';
import 'package:wework/network/core/movieapiprovider.dart';

class MovieRepository {
  final MovieAPiProvider _movieAPiProvider = MovieAPiProvider();
  Future<MoviePage> getMovies(
      {int page = 1,
      bool isNowPlayingMovieRequest = true,
      bool refresh = false}) async {
    var moviePages = await Hive.openBox<MoviePage>(isNowPlayingMovieRequest
        ? AppConstantString.nowPlayingPages
        : AppConstantString.topCategoriesPages);
    var moviePage = moviePages.get(page);
    if (moviePage != null && !moviePage.isExpired() && !refresh) {
      Utils.printLog(runtimeType.toString(), "DB page ${moviePage.page}");
      return Future.value(moviePage);
    } else {
      if (refresh) {
        await Hive.deleteBoxFromDisk(isNowPlayingMovieRequest
            ? AppConstantString.nowPlayingPages
            : AppConstantString.topCategoriesPages);
        moviePages = await Hive.openBox<MoviePage>(isNowPlayingMovieRequest
            ? AppConstantString.nowPlayingPages
            : AppConstantString.topCategoriesPages);
      }
      var apiResult = isNowPlayingMovieRequest
          ? await _movieAPiProvider.getNowPlayingMovies(page)
          : await _movieAPiProvider.getTopPlayingMovies(page);
      if (apiResult.body != null) {
        apiResult.body?.setExpirationTime();
        storeMoviePagesInDataBase(apiResult.body!, moviePages);
        Utils.printLog(
            runtimeType.toString(), "Network page ${apiResult.body?.page}");
        return Future.value(apiResult.body);
      } else {
        return Future.error(apiResult.error);
      }
    }
  }

  storeMoviePagesInDataBase(MoviePage moviePage, Box<MoviePage> movieBox) {
    movieBox.put(moviePage.page, moviePage);
  }
}
