import 'package:flutter/material.dart';
import 'package:farm_up/services/community_service.dart';
import 'package:farm_up/models/community_post.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final CommunityService _communityService = CommunityService();
  List<CommunityPost> _posts = [];
  List<FarmerGroup> _groups = [];
  List<KnowledgeArticle> _articles = [];
  List<String> _trendingTopics = [];
  Map<String, dynamic> _communityStats = {};
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _communityService.initializeSampleData();
    _loadCommunityData();
  }

  void _loadCommunityData() {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = _communityService.getAllPosts();
      final groups = _communityService.getAllGroups();
      final articles = _communityService.getAllKnowledgeArticles();
      final topics = _communityService.getTrendingTopics();
      final stats = _communityService.getCommunityStats();
      
      setState(() {
        _posts = posts;
        _groups = groups;
        _articles = articles;
        _trendingTopics = topics;
        _communityStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load community data: $e')),
        );
      }
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _searchCommunity(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<CommunityPost> _getFilteredPosts() {
    List<CommunityPost> filtered = _posts;
    
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((post) => post.category == _selectedCategory)
          .toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((post) =>
              post.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              post.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              post.farmerName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    
    return filtered;
  }

  void _viewPostDetails(CommunityPost post) {
    if (mounted) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.farmerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${post.location} • ${post.postDate.toString().split(' ').first}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(post.content),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Like functionality
                        if (post.isLikedBy('FARMER001')) {
                          _communityService.unlikePost(post.id!, 'FARMER001');
                        } else {
                          _communityService.likePost(post.id!, 'FARMER001');
                        }
                        _loadCommunityData(); // Refresh data
                      },
                      icon: Icon(
                        post.isLikedBy('FARMER001') 
                            ? Icons.favorite 
                            : Icons.favorite_border,
                        color: post.isLikedBy('FARMER001') 
                            ? Colors.red 
                            : Colors.grey,
                      ),
                    ),
                    Text('${post.likes}'),
                    const SizedBox(width: 20),
                    const Icon(Icons.comment, color: Colors.grey),
                    Text('${post.comments}'),
                    const Spacer(),
                    Chip(
                      label: Text(post.category),
                      backgroundColor: Colors.green[100],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: post.postComments.length,
                    itemBuilder: (context, index) {
                      final comment = post.postComments[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      Icons.person,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    comment.farmerName,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(comment.content),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    comment.commentDate.toString().split(' ').first,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      // Like comment functionality
                                    },
                                    icon: const Icon(
                                      Icons.thumb_up,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text('${comment.likes}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      // Add comment functionality
                      final newComment = PostComment(
                        farmerId: 'FARMER001',
                        farmerName: 'You',
                        content: value,
                        commentDate: DateTime.now(),
                      );
                      _communityService.addCommentToPost(post.id!, newComment);
                      _loadCommunityData(); // Refresh data
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _createPost() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creating new post...')),
      );
    }
  }

  void _joinGroup(FarmerGroup group) {
    _communityService.joinGroup(group.id!, 'FARMER001');
    _loadCommunityData(); // Refresh data
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined ${group.groupName}')),
      );
    }
  }

  void _viewArticle(KnowledgeArticle article) {
    if (mounted) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('By ${article.author}'),
                    const Spacer(),
                    Text(
                      article.publishDate.toString().split(' ').first,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Chip(
                  label: Text(article.category),
                  backgroundColor: Colors.blue[100],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(article.content),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.visibility, size: 16),
                            Text(' ${article.views} views'),
                            const SizedBox(width: 20),
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            Text(' ${article.rating.toStringAsFixed(1)}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 5,
                          children: article.tags
                              .map((tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor: Colors.grey[300],
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _getFilteredPosts();
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Farmer Community'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Groups'),
              Tab(text: 'Knowledge'),
              Tab(text: 'Analytics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Posts Tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search posts...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    onChanged: _searchCommunity,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedCategory == 'All',
                        onSelected: (_) => _filterByCategory('All'),
                        selectedColor: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text('Questions'),
                        selected: _selectedCategory == 'Question',
                        onSelected: (_) => _filterByCategory('Question'),
                        selectedColor: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text('Success Stories'),
                        selected: _selectedCategory == 'Success Story',
                        onSelected: (_) => _filterByCategory('Success Story'),
                        selectedColor: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text('Discussions'),
                        selected: _selectedCategory == 'Discussion',
                        onSelected: (_) => _filterByCategory('Discussion'),
                        selectedColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Trending Topics
                if (_trendingTopics.isNotEmpty)
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const SizedBox(width: 10),
                        const Text(
                          'Trending:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        ..._trendingTopics.map((topic) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Chip(
                                label: Text(topic),
                                backgroundColor: Colors.green[100],
                              ),
                            )),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredPosts.isEmpty
                          ? const Center(
                              child: Text(
                                'No posts found',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: filteredPosts.length,
                              itemBuilder: (context, index) {
                                final post = filteredPosts[index];
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.green,
                                              child: Icon(
                                                Icons.person,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post.farmerName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '${post.location} • ${post.postDate.toString().split(' ').first}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Chip(
                                              label: Text(post.category),
                                              backgroundColor: Colors.green[100],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          post.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          post.content,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                // Like functionality
                                                if (post.isLikedBy('FARMER001')) {
                                                  _communityService.unlikePost(
                                                    post.id!,
                                                    'FARMER001',
                                                  );
                                                } else {
                                                  _communityService.likePost(
                                                    post.id!,
                                                    'FARMER001',
                                                  );
                                                }
                                                _loadCommunityData(); // Refresh data
                                              },
                                              icon: Icon(
                                                post.isLikedBy('FARMER001') 
                                                    ? Icons.favorite 
                                                    : Icons.favorite_border,
                                                color: post.isLikedBy('FARMER001') 
                                                    ? Colors.red 
                                                    : Colors.grey,
                                              ),
                                            ),
                                            Text('${post.likes}'),
                                            const SizedBox(width: 20),
                                            const Icon(Icons.comment, color: Colors.grey),
                                            Text('${post.comments}'),
                                            const Spacer(),
                                            Text(
                                              post.cropType,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
            
            // Groups Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Farmer Groups',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_groups.isEmpty)
                      const Center(
                        child: Text('No groups available'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _groups.length,
                        itemBuilder: (context, index) {
                          final group = _groups[index];
                          return Card(
                            child: ListTile(
                              title: Text(group.groupName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(group.description),
                                  Text(
                                    '${group.memberCount} members • ${group.location}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: group.isMember('FARMER001')
                                  ? const Chip(
                                      label: Text('Member'),
                                      backgroundColor: Colors.green,
                                    )
                                  : ElevatedButton(
                                      onPressed: () => _joinGroup(group),
                                      child: const Text('Join'),
                                    ),
                              onTap: () {
                                // View group details
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Viewing ${group.groupName} details...'),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            
            // Knowledge Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Knowledge Base',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_articles.isEmpty)
                      const Center(
                        child: Text('No knowledge articles available'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _articles.length,
                        itemBuilder: (context, index) {
                          final article = _articles[index];
                          return Card(
                            child: ListTile(
                              title: Text(article.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'By ${article.author}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(article.content),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                      Text('${article.rating.toStringAsFixed(1)}'),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.visibility,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      Text('${article.views}'),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () => _viewArticle(article),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            
            // Analytics Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Community Analytics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Community Stats
                      if (_communityStats.isNotEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Community Overview',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem(
                                      '${_communityStats['totalPosts']}',
                                      'Posts',
                                      Icons.article,
                                    ),
                                    _buildStatItem(
                                      '${_communityStats['totalGroups']}',
                                      'Groups',
                                      Icons.groups,
                                    ),
                                    _buildStatItem(
                                      '${_communityStats['totalArticles']}',
                                      'Articles',
                                      Icons.library_books,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem(
                                      '${_communityStats['totalLikes']}',
                                      'Likes',
                                      Icons.favorite,
                                    ),
                                    _buildStatItem(
                                      '${_communityStats['totalComments']}',
                                      'Comments',
                                      Icons.comment,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Engagement Insights
                      const Text(
                        'Engagement Insights',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const ListTile(
                                leading: Icon(Icons.trending_up, color: Colors.green),
                                title: Text('Most Active Times'),
                                subtitle: Text('Evenings and weekends see highest engagement'),
                              ),
                              const ListTile(
                                leading: Icon(Icons.category, color: Colors.blue),
                                title: Text('Popular Categories'),
                                subtitle: Text('Questions and Success Stories are most popular'),
                              ),
                              const ListTile(
                                leading: Icon(Icons.location_on, color: Colors.orange),
                                title: Text('Regional Activity'),
                                subtitle: Text('Punjab and Maharashtra have most active communities'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createPost,
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}