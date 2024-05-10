import 'package:wework/model/moviepage.dart';
import 'package:wework/network/apiendpoints.dart';
import 'package:wework/network/core/baseapiprovider.dart';

class MovieAPiProvider extends BaseApiProvider {
  static const queryMapKeyLanguage = "language";
  static const queryMapValueLanguage = "en-US";
  static const queryMapKeyPage = "page";

  Future<ApiResult<MoviePage>> getNowPlayingMovies(int page) async {
    Map<String, dynamic> queryMap = {};
    queryMap[queryMapKeyLanguage] = queryMapValueLanguage;
    queryMap[queryMapKeyPage] = page;
    return get(ApiEndPoints.nowPlayingEndPoint,
        queryParameters: queryMap, converter: MoviePage.fromJson);
  }

  Future<ApiResult<MoviePage>> getTopPlayingMovies(int page) async {
    Map<String, dynamic> queryMap = {};
    queryMap[queryMapKeyLanguage] = queryMapValueLanguage;
    queryMap[queryMapKeyPage] = page;
    return get(ApiEndPoints.topRatedEndPoint,
        queryParameters: queryMap, converter: MoviePage.fromJson);
  }
}
