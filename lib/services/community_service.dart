import 'package:farm_up/models/community_post.dart';

class CommunityService {
  List<CommunityPost> _posts = [];
  List<FarmerGroup> _groups = [];
  List<KnowledgeArticle> _knowledgeArticles = [];
  
  // Initialize with sample data
  void initializeSampleData() {
    // Sample community posts
    final post1 = CommunityPost(
      id: 1,
      farmerId: 'FARMER001',
      farmerName: 'Rajesh Kumar',
      title: 'Best irrigation techniques for wheat?',
      content: 'I\'m looking for advice on the most efficient irrigation methods for my wheat crop. My farm is in Punjab and the soil is clayey. Any tips would be greatly appreciated!',
      category: 'Question',
      postDate: DateTime(2025, 4, 10),
      likes: 12,
      comments: 8,
      location: 'Punjab',
      cropType: 'Wheat',
    );
    
    final post2 = CommunityPost(
      id: 2,
      farmerId: 'FARMER002',
      farmerName: 'Priya Sharma',
      title: 'Successful organic cotton harvest!',
      content: 'Just harvested my first organic cotton crop with a 25% higher yield than last year. The key was using neem cake as a natural fertilizer and introducing beneficial insects for pest control.',
      category: 'Success Story',
      postDate: DateTime(2025, 4, 5),
      likes: 24,
      comments: 15,
      location: 'Gujarat',
      cropType: 'Cotton',
    );
    
    final post3 = CommunityPost(
      id: 3,
      farmerId: 'FARMER003',
      farmerName: 'Amit Patel',
      title: 'Dealing with pest infestation',
      content: 'My tomato plants are being attacked by aphids. I\'ve tried spraying soapy water but it\'s not working. Any organic solutions?',
      category: 'Question',
      postDate: DateTime(2025, 4, 12),
      likes: 8,
      comments: 12,
      location: 'Maharashtra',
      cropType: 'Tomatoes',
    );
    
    _posts = [post1, post2, post3];
    
    // Sample farmer groups
    final group1 = FarmerGroup(
      id: 1,
      groupName: 'Punjab Wheat Growers Cooperative',
      description: 'Cooperative for wheat farmers in Punjab to share resources and knowledge',
      category: 'Cooperative',
      memberIds: ['FARMER001', 'FARMER004', 'FARMER005'],
      createdBy: 'FARMER001',
      createdDate: DateTime(2024, 11, 15),
      location: 'Punjab',
      memberCount: 45,
    );
    
    final group2 = FarmerGroup(
      id: 2,
      groupName: 'Organic Farming Enthusiasts',
      description: 'Discussion group for farmers transitioning to organic practices',
      category: 'Discussion Group',
      memberIds: ['FARMER001', 'FARMER002', 'FARMER006'],
      createdBy: 'FARMER002',
      createdDate: DateTime(2025, 1, 20),
      location: 'National',
      memberCount: 120,
    );
    
    _groups = [group1, group2];
    
    // Sample knowledge articles
    final article1 = KnowledgeArticle(
      id: 1,
      title: 'Water Conservation Techniques for Arid Regions',
      content: 'Detailed guide on drip irrigation, mulching, and drought-resistant crop varieties for farmers in water-scarce areas.',
      category: 'Best Practices',
      author: 'Dr. Agricultural Expert',
      publishDate: DateTime(2025, 3, 15),
      views: 340,
      rating: 4.7,
      ratingCount: 28,
      tags: ['water conservation', 'drought', 'irrigation'],
    );
    
    final article2 = KnowledgeArticle(
      id: 2,
      title: 'Natural Pest Control Methods',
      content: 'Comprehensive overview of biological pest control, companion planting, and organic repellents.',
      category: 'Tips',
      author: 'Organic Farming Institute',
      publishDate: DateTime(2025, 2, 28),
      views: 420,
      rating: 4.5,
      ratingCount: 35,
      tags: ['pest control', 'organic', 'natural'],
    );
    
    _knowledgeArticles = [article1, article2];
  }
  
  // Get all community posts
  List<CommunityPost> getAllPosts() {
    return List.from(_posts);
  }
  
  // Get posts by category
  List<CommunityPost> getPostsByCategory(String category) {
    return _posts
        .where((post) => post.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
  
  // Get posts by location
  List<CommunityPost> getPostsByLocation(String location) {
    return _posts
        .where((post) => post.location.toLowerCase() == location.toLowerCase())
        .toList();
  }
  
  // Get posts by crop type
  List<CommunityPost> getPostsByCrop(String cropType) {
    return _posts
        .where((post) => post.cropType.toLowerCase() == cropType.toLowerCase())
        .toList();
  }
  
  // Get post by ID
  CommunityPost? getPostById(int id) {
    try {
      return _posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Add new post
  void addPost(CommunityPost post) {
    _posts.add(post);
  }
  
  // Like a post
  void likePost(int postId, String farmerId) {
    final post = getPostById(postId);
    if (post != null && !post.isLikedBy(farmerId)) {
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = CommunityPost(
          id: post.id,
          farmerId: post.farmerId,
          farmerName: post.farmerName,
          title: post.title,
          content: post.content,
          category: post.category,
          postDate: post.postDate,
          likes: post.likes + 1,
          comments: post.comments,
          likedBy: [...post.likedBy, farmerId],
          postComments: post.postComments,
          location: post.location,
          cropType: post.cropType,
        );
      }
    }
  }
  
  // Unlike a post
  void unlikePost(int postId, String farmerId) {
    final post = getPostById(postId);
    if (post != null && post.isLikedBy(farmerId)) {
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = CommunityPost(
          id: post.id,
          farmerId: post.farmerId,
          farmerName: post.farmerName,
          title: post.title,
          content: post.content,
          category: post.category,
          postDate: post.postDate,
          likes: post.likes - 1,
          comments: post.comments,
          likedBy: post.likedBy.where((id) => id != farmerId).toList(),
          postComments: post.postComments,
          location: post.location,
          cropType: post.cropType,
        );
      }
    }
  }
  
  // Add comment to a post
  void addCommentToPost(int postId, PostComment comment) {
    final post = getPostById(postId);
    if (post != null) {
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = CommunityPost(
          id: post.id,
          farmerId: post.farmerId,
          farmerName: post.farmerName,
          title: post.title,
          content: post.content,
          category: post.category,
          postDate: post.postDate,
          likes: post.likes,
          comments: post.comments + 1,
          likedBy: post.likedBy,
          postComments: [...post.postComments, comment],
          location: post.location,
          cropType: post.cropType,
        );
      }
    }
  }
  
  // Get all farmer groups
  List<FarmerGroup> getAllGroups() {
    return List.from(_groups);
  }
  
  // Get groups by category
  List<FarmerGroup> getGroupsByCategory(String category) {
    return _groups
        .where((group) => group.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
  
  // Get groups by location
  List<FarmerGroup> getGroupsByLocation(String location) {
    return _groups
        .where((group) => group.location.toLowerCase() == location.toLowerCase())
        .toList();
  }
  
  // Get group by ID
  FarmerGroup? getGroupById(int id) {
    try {
      return _groups.firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Join a group
  void joinGroup(int groupId, String farmerId) {
    final group = getGroupById(groupId);
    if (group != null && !group.isMember(farmerId)) {
      final index = _groups.indexWhere((g) => g.id == groupId);
      if (index != -1) {
        _groups[index] = FarmerGroup(
          id: group.id,
          groupName: group.groupName,
          description: group.description,
          category: group.category,
          memberIds: [...group.memberIds, farmerId],
          createdBy: group.createdBy,
          createdDate: group.createdDate,
          location: group.location,
          memberCount: group.memberCount + 1,
        );
      }
    }
  }
  
  // Leave a group
  void leaveGroup(int groupId, String farmerId) {
    final group = getGroupById(groupId);
    if (group != null && group.isMember(farmerId)) {
      final index = _groups.indexWhere((g) => g.id == groupId);
      if (index != -1) {
        _groups[index] = FarmerGroup(
          id: group.id,
          groupName: group.groupName,
          description: group.description,
          category: group.category,
          memberIds: group.memberIds.where((id) => id != farmerId).toList(),
          createdBy: group.createdBy,
          createdDate: group.createdDate,
          location: group.location,
          memberCount: group.memberCount - 1,
        );
      }
    }
  }
  
  // Get all knowledge articles
  List<KnowledgeArticle> getAllKnowledgeArticles() {
    return List.from(_knowledgeArticles);
  }
  
  // Get articles by category
  List<KnowledgeArticle> getArticlesByCategory(String category) {
    return _knowledgeArticles
        .where((article) => article.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
  
  // Get articles by tag
  List<KnowledgeArticle> getArticlesByTag(String tag) {
    return _knowledgeArticles
        .where((article) => 
            article.tags.any((t) => t.toLowerCase() == tag.toLowerCase()))
        .toList();
  }
  
  // Get article by ID
  KnowledgeArticle? getArticleById(int id) {
    try {
      return _knowledgeArticles.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Search posts, groups, and articles
  Map<String, List<dynamic>> searchCommunity(String query) {
    final results = <String, List<dynamic>>{
      'posts': [],
      'groups': [],
      'articles': [],
    };
    
    // Search posts
    results['posts'] = _posts
        .where((post) =>
            post.title.toLowerCase().contains(query.toLowerCase()) ||
            post.content.toLowerCase().contains(query.toLowerCase()) ||
            post.farmerName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    
    // Search groups
    results['groups'] = _groups
        .where((group) =>
            group.groupName.toLowerCase().contains(query.toLowerCase()) ||
            group.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
    
    // Search articles
    results['articles'] = _knowledgeArticles
        .where((article) =>
            article.title.toLowerCase().contains(query.toLowerCase()) ||
            article.content.toLowerCase().contains(query.toLowerCase()) ||
            article.author.toLowerCase().contains(query.toLowerCase()) ||
            article.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
        .toList();
    
    return results;
  }
  
  // Get trending topics
  List<String> getTrendingTopics() {
    final topics = <String>{};
    
    // Extract topics from posts
    for (final post in _posts) {
      topics.add(post.cropType);
      topics.add(post.location);
      if (post.category == 'Question') {
        // Extract potential topics from question titles
        if (post.title.toLowerCase().contains('irrigation')) topics.add('Irrigation');
        if (post.title.toLowerCase().contains('pest')) topics.add('Pest Control');
        if (post.title.toLowerCase().contains('fertilizer')) topics.add('Fertilization');
      }
    }
    
    // Extract topics from articles
    for (final article in _knowledgeArticles) {
      topics.addAll(article.tags);
    }
    
    return topics.take(10).toList();
  }
  
  // Get community statistics
  Map<String, dynamic> getCommunityStats() {
    final stats = <String, dynamic>{};
    
    // Total posts
    stats['totalPosts'] = _posts.length;
    
    // Posts by category
    final postCategories = <String, int>{};
    for (final post in _posts) {
      if (postCategories.containsKey(post.category)) {
        postCategories[post.category] = postCategories[post.category]! + 1;
      } else {
        postCategories[post.category] = 1;
      }
    }
    stats['postCategories'] = postCategories;
    
    // Total groups
    stats['totalGroups'] = _groups.length;
    
    // Groups by category
    final groupCategories = <String, int>{};
    for (final group in _groups) {
      if (groupCategories.containsKey(group.category)) {
        groupCategories[group.category] = groupCategories[group.category]! + 1;
      } else {
        groupCategories[group.category] = 1;
      }
    }
    stats['groupCategories'] = groupCategories;
    
    // Total articles
    stats['totalArticles'] = _knowledgeArticles.length;
    
    // Articles by category
    final articleCategories = <String, int>{};
    for (final article in _knowledgeArticles) {
      if (articleCategories.containsKey(article.category)) {
        articleCategories[article.category] = articleCategories[article.category]! + 1;
      } else {
        articleCategories[article.category] = 1;
      }
    }
    stats['articleCategories'] = articleCategories;
    
    // Total likes
    int totalLikes = 0;
    for (final post in _posts) {
      totalLikes += post.likes;
    }
    stats['totalLikes'] = totalLikes;
    
    // Total comments
    int totalComments = 0;
    for (final post in _posts) {
      totalComments += post.comments;
    }
    stats['totalComments'] = totalComments;
    
    return stats;
  }
}