import 'package:flutter/material.dart';
import 'package:storifuel/models/story_model.dart';
import 'package:storifuel/services/firebase/story_service.dart';

class HomeProvider extends ChangeNotifier {
  final List<String> _selectedCategories = [];
  List<String> _availableCategories = [];
  final Set<String> _favoritedStories = <String>{};
  final StoryService _storyService = StoryService();
  
  List<StoryModel> _allStories = [];
  List<StoryModel> _filteredStories = [];
  List<String> _filteredCategories = [];
  String _searchQuery = '';
  String _categorySearchQuery = '';
  bool _isLoading = false;

  List<String> get selectedCategories => List.unmodifiable(_selectedCategories);
  List<String> get availableCategories => _categorySearchQuery.isEmpty 
      ? List.unmodifiable(_availableCategories) 
      : List.unmodifiable(_filteredCategories);
  Set<String> get favoritedStories => Set.unmodifiable(_favoritedStories);
  List<StoryModel> get allStories => List.unmodifiable(_allStories);
  List<StoryModel> get filteredStories => List.unmodifiable(_filteredStories);
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  // Filter management methods
  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    _applyFiltersAndSearch();
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategories.clear();
    _applyFiltersAndSearch();
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
    _updateAvailableCategories();
    _applyFiltersAndSearch();
    notifyListeners();
  }

  // Update available categories from user's actual stories
  void _updateAvailableCategories() {
    final categories = _allStories.map((story) => story.category).toSet().toList();
    categories.sort(); // Sort alphabetically
    _availableCategories = categories;
    _filterCategoriesBySearch();
  }

  // Public method to update only categories without full rebuild
  void updateAvailableCategories(List<String> categories) {
    _availableCategories = categories;
    _filterCategoriesBySearch();
    notifyListeners();
  }

  // Main search functionality for stories
  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    _applyFiltersAndSearch();
    notifyListeners();
  }

  // Search functionality for categories in bottom sheet
  void updateCategorySearchQuery(String query) {
    _categorySearchQuery = query.trim();
    _filterCategoriesBySearch();
    notifyListeners();
  }

  // Filter categories based on search query
  void _filterCategoriesBySearch() {
    if (_categorySearchQuery.isEmpty) {
      _filteredCategories = List.from(_availableCategories);
    } else {
      final lowercaseQuery = _categorySearchQuery.toLowerCase();
      _filteredCategories = _availableCategories
          .where((category) => category.toLowerCase().contains(lowercaseQuery))
          .toList();
    }
  }

  // Apply both category filters and search query
  void _applyFiltersAndSearch() {
    List<StoryModel> result = List.from(_allStories);

    // Apply category filter
    if (_selectedCategories.isNotEmpty) {
      result = result.where((story) => _selectedCategories.contains(story.category)).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final lowercaseQuery = _searchQuery.toLowerCase();
      result = result.where((story) {
        return story.title.toLowerCase().contains(lowercaseQuery) ||
               story.description.toLowerCase().contains(lowercaseQuery) ||
               story.category.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }

    _filteredStories = result;
  }

  // Clear all filters and search
  void clearAllFilters() {
    _selectedCategories.clear();
    _searchQuery = '';
    _categorySearchQuery = '';
    _applyFiltersAndSearch();
    notifyListeners();
  }
}
