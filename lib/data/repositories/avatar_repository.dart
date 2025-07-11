import '../services/pexels_api_service.dart';
import '../../core/constants/app_constants.dart';

class AvatarRepository {
  final PexelsApiService _apiService;

  AvatarRepository(this._apiService);

  Future<List<String>> getAvatarOptions({String query = 'portrait person'}) async {
    try {
      final response = await _apiService.searchPhotos(
        AppConstants.pexelsApiKey,
        query,
        15, // per_page
        1, // page
      );

      return response.photos.map((photo) => photo.src.medium).toList();
    } catch (e) {
      // Return some default avatar URLs if API fails
      return _getDefaultAvatars();
    }
  }

  Future<List<String>> getCuratedAvatars() async {
    try {
      final response = await _apiService.getCuratedPhotos(
        AppConstants.pexelsApiKey,
        15, // per_page
        1, // page
      );

      // Filter for portrait-oriented photos for better avatars
      final portraits = response.photos
          .where((photo) => photo.height >= photo.width)
          .map((photo) => photo.src.medium)
          .toList();

      return portraits.isNotEmpty ? portraits : response.photos.map((photo) => photo.src.medium).toList();
    } catch (e) {
      return _getDefaultAvatars();
    }
  }

  Future<List<String>> getRandomAvatars() async {
    final queries = ['portrait', 'face', 'person', 'headshot', 'profile'];
    final randomQuery = queries[DateTime.now().millisecondsSinceEpoch % queries.length];
    
    return await getAvatarOptions(query: randomQuery);
  }

  List<String> _getDefaultAvatars() {
    // Return some default avatar URLs as fallback
    return [
      'https://images.unsplash.com/photo-1494790108755-2616c36a46ba?w=400&h=400&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=400&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&h=400&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?w=400&h=400&fit=crop&crop=face',
    ];
  }
} 