import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final List<String> _selectedCategories = [];
  final List<String> _availableCategories = ['Business', 'Crypto', 'Technology', 'Gaming'];
  final Set<String> _favoritedStories = <String>{};

  List<String> get selectedCategories => List.unmodifiable(_selectedCategories);
  List<String> get availableCategories => List.unmodifiable(_availableCategories);
  Set<String> get favoritedStories => Set.unmodifiable(_favoritedStories);

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
}
