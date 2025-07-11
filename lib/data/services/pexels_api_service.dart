import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pexels_api_service.g.dart';

@JsonSerializable()
class PexelsPhoto {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  @JsonKey(name: 'photographer_url')
  final String photographerUrl;
  @JsonKey(name: 'photographer_id')
  final int photographerId;
  @JsonKey(name: 'avg_color')
  final String avgColor;
  final PexelsPhotoSrc src;
  final bool liked;
  final String alt;

  PexelsPhoto({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.src,
    required this.liked,
    required this.alt,
  });

  factory PexelsPhoto.fromJson(Map<String, dynamic> json) => 
      _$PexelsPhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PexelsPhotoToJson(this);
}

@JsonSerializable()
class PexelsPhotoSrc {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  PexelsPhotoSrc({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory PexelsPhotoSrc.fromJson(Map<String, dynamic> json) => 
      _$PexelsPhotoSrcFromJson(json);
  Map<String, dynamic> toJson() => _$PexelsPhotoSrcToJson(this);
}

@JsonSerializable()
class PexelsResponse {
  final List<PexelsPhoto> photos;
  final int page;
  @JsonKey(name: 'per_page')
  final int perPage;
  @JsonKey(name: 'total_results')
  final int totalResults;
  @JsonKey(name: 'next_page')
  final String? nextPage;

  PexelsResponse({
    required this.photos,
    required this.page,
    required this.perPage,
    required this.totalResults,
    this.nextPage,
  });

  factory PexelsResponse.fromJson(Map<String, dynamic> json) => 
      _$PexelsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PexelsResponseToJson(this);
}

@RestApi(baseUrl: 'https://api.pexels.com/v1')
abstract class PexelsApiService {
  factory PexelsApiService(Dio dio, {String baseUrl}) = _PexelsApiService;

  @GET('/search')
  Future<PexelsResponse> searchPhotos(
    @Header('Authorization') String authorization,
    @Query('query') String query,
    @Query('per_page') int perPage,
    @Query('page') int page,
  );

  @GET('/curated')
  Future<PexelsResponse> getCuratedPhotos(
    @Header('Authorization') String authorization,
    @Query('per_page') int perPage,
    @Query('page') int page,
  );
} 