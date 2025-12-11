class VideoTutorial {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String thumbnailUrl;
  final String videoUrl;
  final int durationSeconds;
  final DateTime uploadDate;
  final String author;
  final int views;
  final double rating;
  final bool isFavorite;

  VideoTutorial({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.durationSeconds,
    required this.uploadDate,
    required this.author,
    this.views = 0,
    this.rating = 0.0,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'durationSeconds': durationSeconds,
      'uploadDate': uploadDate.toIso8601String(),
      'author': author,
      'views': views,
      'rating': rating,
      'isFavorite': isFavorite,
    };
  }

  factory VideoTutorial.fromJson(Map<String, dynamic> json) {
    return VideoTutorial(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      thumbnailUrl: json['thumbnailUrl'],
      videoUrl: json['videoUrl'],
      durationSeconds: json['durationSeconds'],
      uploadDate: DateTime.parse(json['uploadDate']),
      author: json['author'],
      views: json['views'] ?? 0,
      rating: json['rating'] ?? 0.0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }
  
  String getDurationString {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}