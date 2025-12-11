import 'package:flutter/material.dart';
import 'package:farm_up/services/video_library_service.dart';
import 'package:farm_up/models/video_tutorial.dart';

class VideoLibraryScreen extends StatefulWidget {
  const VideoLibraryScreen({super.key});

  @override
  State<VideoLibraryScreen> createState() => _VideoLibraryScreenState();
}

class _VideoLibraryScreenState extends State<VideoLibraryScreen> {
  final VideoLibraryService _videoService = VideoLibraryService();
  List<VideoTutorial> _allVideos = [];
  List<VideoTutorial> _filteredVideos = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final videos = await _videoService.getAllVideos();
      final categories = _videoService.getCategories();
      
      setState(() {
        _allVideos = videos;
        _filteredVideos = videos;
        _categories = ['All', ...categories];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load videos: $e')),
        );
      }
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      
      if (category == 'All') {
        _filteredVideos = _allVideos;
      } else {
        _filteredVideos = _allVideos
            .where((video) => video.category == category)
            .toList();
      }
    });
  }

  void _searchVideos(String query) {
    setState(() {
      _searchQuery = query;
      
      if (query.isEmpty) {
        _filterByCategory(_selectedCategory);
      } else {
        _filteredVideos = _allVideos
            .where((video) =>
                video.title.toLowerCase().contains(query.toLowerCase()) ||
                video.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleFavorite(VideoTutorial video) async {
    await _videoService.toggleFavorite(video.id!);
    _loadVideos(); // Refresh the list
  }

  void _playVideo(VideoTutorial video) async {
    await _videoService.incrementViewCount(video.id!);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playing: ${video.title}'),
          duration: const Duration(seconds: 1),
        ),
      );
      
      // In a real app, this would open a video player
      // For simulation, we'll just show a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(video.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  video.thumbnailUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(video.description),
                const SizedBox(height: 10),
                Text('Duration: ${video.getDurationString}'),
                Text('Author: ${video.author}'),
                Text('Views: ${video.views + 1}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Library'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search videos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              onChanged: _searchVideos,
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (_) => _filterByCategory(category),
                    selectedColor: Colors.green,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredVideos.isEmpty
                    ? const Center(
                        child: Text(
                          'No videos found',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _filteredVideos.length,
                        itemBuilder: (context, index) {
                          final video = _filteredVideos[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => _playVideo(video),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Image.asset(
                                        video.thumbnailUrl,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        right: 5,
                                        bottom: 5,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 2,
                                          ),
                                          color: Colors.black54,
                                          child: Text(
                                            video.getDurationString,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          video.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          video.category,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${video.views} views',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              icon: Icon(
                                                video.isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: video.isFavorite
                                                    ? Colors.red
                                                    : Colors.grey,
                                                size: 18,
                                              ),
                                              onPressed: () => _toggleFavorite(video),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
    );
  }
}