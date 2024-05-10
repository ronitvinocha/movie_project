import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wework/common/utils.dart';

part 'moviepage.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class MoviePage {
  @HiveField(0)
  final int page;
  @HiveField(1)
  final List<Movie> results;
  @HiveField(2)
  @JsonKey(name: "total_pages")
  final int totalPages;
  @HiveField(3)
  @JsonKey(name: "total_results")
  final int totalResults;
  @HiveField(4)
  final Dates? dates;
  @HiveField(5)
  int? expirationTime;
  MoviePage(
      {required this.dates,
      required this.page,
      required this.results,
      required this.totalPages,
      required this.totalResults,
      this.expirationTime});

  factory MoviePage.fromJson(Map<String, dynamic> json) =>
      _$MoviePageFromJson(json);

  Map<String, dynamic> toJson() => _$MoviePageToJson(this);

  setExpirationTime() {
    var expirationTime =
        DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch;
    this.expirationTime = expirationTime;
  }

  bool isExpired() {
    if (expirationTime == null) {
      return true;
    } else {
      var expirationDateTime =
          DateTime.fromMillisecondsSinceEpoch(expirationTime!);
      Utils.printLog("MovieRepository",
          "expiration time ${expirationDateTime.toString()}");
      if (expirationDateTime.isBefore(DateTime.now())) {
        return true;
      } else {
        return false;
      }
    }
  }
}

@JsonSerializable()
@HiveType(typeId: 2)
class Dates {
  @HiveField(0)
  final String maximum;
  @HiveField(1)
  final String minimum;

  Dates({required this.maximum, required this.minimum});

  factory Dates.fromJson(Map<String, dynamic> json) => _$DatesFromJson(json);

  Map<String, dynamic> toJson() => _$DatesToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 1)
class Movie {
  @HiveField(0)
  final bool adult;
  @HiveField(1)
  @JsonKey(name: "backdrop_path")
  final String? backdropPath;
  @HiveField(2)
  @JsonKey(name: "genre_ids")
  final List<int>? genreIds;
  @HiveField(3)
  final int id;
  @HiveField(4)
  @JsonKey(name: "original_language")
  final String? originalLanguage;
  @HiveField(5)
  @JsonKey(name: "original_title")
  final String? originalTitle;
  @HiveField(6)
  final String? overview;
  @HiveField(7)
  final double? popularity;
  @HiveField(8)
  @JsonKey(name: "poster_path")
  final String? posterPath;
  @HiveField(9)
  @JsonKey(name: "release_date")
  final String? releaseDate;
  @HiveField(10)
  final String? title;
  @HiveField(11)
  final bool video;
  @HiveField(12)
  @JsonKey(name: "vote_average")
  final double? voteAverage;
  @HiveField(13)
  @JsonKey(name: "vote_count")
  final int? voteCount;
  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
