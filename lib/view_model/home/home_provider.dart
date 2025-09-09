import 'package:flutter/material.dart';
import 'package:storifuel/models/story_model.dart';
import 'package:storifuel/services/firebase/story_service.dart';

class HomeProvider extends ChangeNotifier {
  final List<String> _selectedCategories = [];
  final List<String> _availableCategories = ['Business', 'Crypto', 'Technology', 'Gaming'];
  final Set<String> _favoritedStories = <String>{};
  final StoryService _storyService = StoryService();
  
  List<StoryModel> _allStories = [];
  bool _isLoading = false;

  List<String> get selectedCategories => List.unmodifiable(_selectedCategories);
  List<String> get availableCategories => List.unmodifiable(_availableCategories);
  Set<String> get favoritedStories => Set.unmodifiable(_favoritedStories);
  List<StoryModel> get allStories => List.unmodifiable(_allStories);
  bool get isLoading => _isLoading;

  // Filter management methods
  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategories.clear();
    notifyListeners();
  }

  bool isCategorySelected(String category) {
    return _selectedCategories.contains(category);
  }

  // Favorite management methods
  void toggleFavorite(String storyId) {
    if (_favoritedStories.contains(storyId)) {
      _favoritedStories.remove(storyId);
    } else {
      _favoritedStories.add(storyId);
    }
    notifyListeners();
  }

  bool isStoryFavorited(String storyId) {
    return _favoritedStories.contains(storyId);
  }

  void clearFavorites() {
    _favoritedStories.clear();
    notifyListeners();
  }

  // Story management methods
  Stream<List<StoryModel>> getStoriesStream() {
    return _storyService.getStories();
  }

  Future<void> loadStories() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _allStories = await _storyService.getStoriesOnce();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Get filtered stories
  List<StoryModel> getFilteredStories() {
    if (_selectedCategories.isEmpty) {
      return _allStories;
    }
    
    return _allStories.where((story) {
      return _selectedCategories.contains(story.category);
    }).toList();
  }

  // Search stories
  List<StoryModel> searchStories(String query) {
    if (query.isEmpty) return getFilteredStories();
    
    final lowercaseQuery = query.toLowerCase();
    final filteredStories = getFilteredStories();
    
    return filteredStories.where((story) {
      return story.title.toLowerCase().contains(lowercaseQuery) ||
             story.description.toLowerCase().contains(lowercaseQuery) ||
             story.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  void updateStories(List<StoryModel> stories) {
    _allStories = stories;
    notifyListeners();
  }
}
