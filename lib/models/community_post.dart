class CommunityPost {
  final int? id;
  final String farmerId;
  final String farmerName;
  final String title;
  final String content;
  final String category; // Question, Advice, Success Story, Discussion
  final DateTime postDate;
  final int likes;
  final int comments;
  final List<String> likedBy;
  final List<PostComment> postComments;
  final String location;
  final String cropType;

  CommunityPost({
    this.id,
    required this.farmerId,
    required this.farmerName,
    required this.title,
    required this.content,
    required this.category,
    required this.postDate,
    this.likes = 0,
    this.comments = 0,
    List<String>? likedBy,
    List<PostComment>? postComments,
    required this.location,
    required this.cropType,
  })  : likedBy = likedBy ?? [],
        postComments = postComments ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'title': title,
      'content': content,
      'category': category,
      'postDate': postDate.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'likedBy': likedBy,
      'postComments': postComments.map((pc) => pc.toJson()).toList(),
      'location': location,
      'cropType': cropType,
    };
  }

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'],
      farmerId: json['farmerId'],
      farmerName: json['farmerName'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      postDate: DateTime.parse(json['postDate']),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      postComments: (json['postComments'] as List)
          .map((pc) => PostComment.fromJson(pc))
          .toList(),
      location: json['location'],
      cropType: json['cropType'],
    );
  }

  bool isLikedBy(String farmerId) {
    return likedBy.contains(farmerId);
  }
}

class PostComment {
  final int? id;
  final String farmerId;
  final String farmerName;
  final String content;
  final DateTime commentDate;
  final int likes;
  final List<String> likedBy;

  PostComment({
    this.id,
    required this.farmerId,
    required this.farmerName,
    required this.content,
    required this.commentDate,
    this.likes = 0,
    List<String>? likedBy,
  }) : likedBy = likedBy ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'content': content,
      'commentDate': commentDate.toIso8601String(),
      'likes': likes,
      'likedBy': likedBy,
    };
  }

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'],
      farmerId: json['farmerId'],
      farmerName: json['farmerName'],
      content: json['content'],
      commentDate: DateTime.parse(json['commentDate']),
      likes: json['likes'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  bool isLikedBy(String farmerId) {
    return likedBy.contains(farmerId);
  }
}

class FarmerGroup {
  final int? id;
  final String groupName;
  final String description;
  final String category; // Cooperative, Discussion Group, Buying Group
  final List<String> memberIds;
  final String createdBy;
  final DateTime createdDate;
  final String location;
  final int memberCount;

  FarmerGroup({
    this.id,
    required this.groupName,
    required this.description,
    required this.category,
    List<String>? memberIds,
    required this.createdBy,
    required this.createdDate,
    required this.location,
    this.memberCount = 1,
  }) : memberIds = memberIds ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupName': groupName,
      'description': description,
      'category': category,
      'memberIds': memberIds,
      'createdBy': createdBy,
      'createdDate': createdDate.toIso8601String(),
      'location': location,
      'memberCount': memberCount,
    };
  }

  factory FarmerGroup.fromJson(Map<String, dynamic> json) {
    return FarmerGroup(
      id: json['id'],
      groupName: json['groupName'],
      description: json['description'],
      category: json['category'],
      memberIds: List<String>.from(json['memberIds'] ?? []),
      createdBy: json['createdBy'],
      createdDate: DateTime.parse(json['createdDate']),
      location: json['location'],
      memberCount: json['memberCount'] ?? 1,
    );
  }

  bool isMember(String farmerId) {
    return memberIds.contains(farmerId);
  }
}

class KnowledgeArticle {
  final int? id;
  final String title;
  final String content;
  final String category; // Best Practices, Tips, Research, Case Studies
  final String author;
  final DateTime publishDate;
  final int views;
  final double rating;
  final int ratingCount;
  final List<String> tags;

  KnowledgeArticle({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.author,
    required this.publishDate,
    this.views = 0,
    this.rating = 0.0,
    this.ratingCount = 0,
    List<String>? tags,
  }) : tags = tags ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'author': author,
      'publishDate': publishDate.toIso8601String(),
      'views': views,
      'rating': rating,
      'ratingCount': ratingCount,
      'tags': tags,
    };
  }

  factory KnowledgeArticle.fromJson(Map<String, dynamic> json) {
    return KnowledgeArticle(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      author: json['author'],
      publishDate: DateTime.parse(json['publishDate']),
      views: json['views'] ?? 0,
      rating: json['rating'] ?? 0.0,
      ratingCount: json['ratingCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}