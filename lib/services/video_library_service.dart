import 'package:farm_up/models/video_tutorial.dart';

class VideoLibraryService {
  // Mock video database
  final List<VideoTutorial> _videos = [
    VideoTutorial(
      id: 1,
      title: 'Introduction to Organic Farming',
      description: 'Learn the basics of organic farming practices and principles.',
      category: 'Organic Farming',
      thumbnailUrl: 'assets/images/video_thumb_1.jpg',
      videoUrl: 'https://example.com/videos/organic_farming_intro.mp4',
      durationSeconds: 360,
      uploadDate: DateTime(2025, 1, 15),
      author: 'Dr. Agricultural Expert',
      views: 12500,
      rating: 4.8,
    ),
    VideoTutorial(
      id: 2,
      title: 'Soil Preparation Techniques',
      description: 'Proper soil preparation is key to successful crop growth.',
      category: 'Soil Management',
      thumbnailUrl: 'assets/images/video_thumb_2.jpg',
      videoUrl: 'https://example.com/videos/soil_prep.mp4',
      durationSeconds: 420,
      uploadDate: DateTime(2025, 2, 3),
      author: 'Farm Master',
      views: 9800,
      rating: 4.6,
    ),
    VideoTutorial(
      id: 3,
      title: 'Pest Control Without Chemicals',
      description: 'Natural methods to protect your crops from pests.',
      category: 'Pest Management',
      thumbnailUrl: 'assets/images/video_thumb_3.jpg',
      videoUrl: 'https://example.com/videos/natural_pest_control.mp4',
      durationSeconds: 510,
      uploadDate: DateTime(2025, 3, 22),
      author: 'Eco Farmer',
      views: 15200,
      rating: 4.9,
    ),
    VideoTutorial(
      id: 4,
      title: 'Efficient Irrigation Systems',
      description: 'Maximize water usage with modern irrigation techniques.',
      category: 'Water Management',
      thumbnailUrl: 'assets/images/video_thumb_4.jpg',
      videoUrl: 'https://example.com/videos/irrigation_systems.mp4',
      durationSeconds: 630,
      uploadDate: DateTime(2025, 4, 10),
      author: 'Water Specialist',
      views: 8700,
      rating: 4.7,
    ),
    VideoTutorial(
      id: 5,
      title: 'Seasonal Planting Guide',
      description: 'What to plant and when for optimal yields.',
      category: 'Planting',
      thumbnailUrl: 'assets/images/video_thumb_5.jpg',
      videoUrl: 'https://example.com/videos/seasonal_planting.mp4',
      durationSeconds: 480,
      uploadDate: DateTime(2025, 5, 5),
      author: 'Seasonal Expert',
      views: 11300,
      rating: 4.5,
    ),
    VideoTutorial(
      id: 6,
      title: 'Harvesting Best Practices',
      description: 'Techniques to maximize yield during harvest season.',
      category: 'Harvesting',
      thumbnailUrl: 'assets/images/video_thumb_6.jpg',
      videoUrl: 'https://example.com/videos/harvesting_practices.mp4',
      durationSeconds: 390,
      uploadDate: DateTime(2025, 6, 18),
      author: 'Harvest Pro',
      views: 7600,
      rating: 4.4,
    ),
  ];

  // Get all videos
  Future<List<VideoTutorial>> getAllVideos() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return _videos;
  }

  // Get videos by category
  Future<List<VideoTutorial>> getVideosByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    return _videos.where((video) => video.category == category).toList();
  }

  // Get favorite videos
  Future<List<VideoTutorial>> getFavoriteVideos() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    return _videos.where((video) => video.isFavorite).toList();
  }

  // Search videos by title or description
  Future<List<VideoTutorial>> searchVideos(String query) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    return _videos
        .where((video) =>
            video.title.toLowerCase().contains(query.toLowerCase()) ||
            video.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get unique categories
  List<String> getCategories() {
    final categories = <String>{};
    for (final video in _videos) {
      categories.add(video.category);
    }
    return categories.toList();
  }

  // Toggle favorite status
  Future<void> toggleFavorite(int videoId) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate network delay
    final index = _videos.indexWhere((video) => video.id == videoId);
    if (index != -1) {
      _videos[index] = VideoTutorial(
        id: _videos[index].id,
        title: _videos[index].title,
        description: _videos[index].description,
        category: _videos[index].category,
        thumbnailUrl: _videos[index].thumbnailUrl,
        videoUrl: _videos[index].videoUrl,
        durationSeconds: _videos[index].durationSeconds,
        uploadDate: _videos[index].uploadDate,
        author: _videos[index].author,
        views: _videos[index].views,
        rating: _videos[index].rating,
        isFavorite: !_videos[index].isFavorite,
      );
    }
  }

  // Increment view count
  Future<void> incrementViewCount(int videoId) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate network delay
    final index = _videos.indexWhere((video) => video.id == videoId);
    if (index != -1) {
      _videos[index] = VideoTutorial(
        id: _videos[index].id,
        title: _videos[index].title,
        description: _videos[index].description,
        category: _videos[index].category,
        thumbnailUrl: _videos[index].thumbnailUrl,
        videoUrl: _videos[index].videoUrl,
        durationSeconds: _videos[index].durationSeconds,
        uploadDate: _videos[index].uploadDate,
        author: _videos[index].author,
        views: _videos[index].views + 1,
        rating: _videos[index].rating,
        isFavorite: _videos[index].isFavorite,
      );
    }
  }
}