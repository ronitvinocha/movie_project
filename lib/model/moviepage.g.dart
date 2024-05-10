// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moviepage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoviePageAdapter extends TypeAdapter<MoviePage> {
  @override
  final int typeId = 0;

  @override
  MoviePage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoviePage(
      dates: fields[4] as Dates?,
      page: fields[0] as int,
      results: (fields[1] as List).cast<Movie>(),
      totalPages: fields[2] as int,
      totalResults: fields[3] as int,
      expirationTime: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MoviePage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.results)
      ..writeByte(2)
      ..write(obj.totalPages)
      ..writeByte(3)
      ..write(obj.totalResults)
      ..writeByte(4)
      ..write(obj.dates)
      ..writeByte(5)
      ..write(obj.expirationTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoviePageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DatesAdapter extends TypeAdapter<Dates> {
  @override
  final int typeId = 2;

  @override
  Dates read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dates(
      maximum: fields[0] as String,
      minimum: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Dates obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.maximum)
      ..writeByte(1)
      ..write(obj.minimum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 1;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      adult: fields[0] as bool,
      backdropPath: fields[1] as String?,
      genreIds: (fields[2] as List?)?.cast<int>(),
      id: fields[3] as int,
      originalLanguage: fields[4] as String?,
      originalTitle: fields[5] as String?,
      overview: fields[6] as String?,
      popularity: fields[7] as double?,
      posterPath: fields[8] as String?,
      releaseDate: fields[9] as String?,
      title: fields[10] as String?,
      video: fields[11] as bool,
      voteAverage: fields[12] as double?,
      voteCount: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.adult)
      ..writeByte(1)
      ..write(obj.backdropPath)
      ..writeByte(2)
      ..write(obj.genreIds)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.originalLanguage)
      ..writeByte(5)
      ..write(obj.originalTitle)
      ..writeByte(6)
      ..write(obj.overview)
      ..writeByte(7)
      ..write(obj.popularity)
      ..writeByte(8)
      ..write(obj.posterPath)
      ..writeByte(9)
      ..write(obj.releaseDate)
      ..writeByte(10)
      ..write(obj.title)
      ..writeByte(11)
      ..write(obj.video)
      ..writeByte(12)
      ..write(obj.voteAverage)
      ..writeByte(13)
      ..write(obj.voteCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoviePage _$MoviePageFromJson(Map<String, dynamic> json) => MoviePage(
      dates: json['dates'] == null
          ? null
          : Dates.fromJson(json['dates'] as Map<String, dynamic>),
      page: (json['page'] as num).toInt(),
      results: (json['results'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
      expirationTime: (json['expirationTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MoviePageToJson(MoviePage instance) => <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'dates': instance.dates?.toJson(),
      'expirationTime': instance.expirationTime,
    };

Dates _$DatesFromJson(Map<String, dynamic> json) => Dates(
      maximum: json['maximum'] as String,
      minimum: json['minimum'] as String,
    );

Map<String, dynamic> _$DatesToJson(Dates instance) => <String, dynamic>{
      'maximum': instance.maximum,
      'minimum': instance.minimum,
    };

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      adult: json['adult'] as bool,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      id: (json['id'] as num).toInt(),
      originalLanguage: json['original_language'] as String?,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      title: json['title'] as String?,
      video: json['video'] as bool,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'release_date': instance.releaseDate,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
