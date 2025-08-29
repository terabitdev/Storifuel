import 'package:flutter/material.dart';

class FavouriteProvider extends ChangeNotifier {
  final Set<String> _favoritedStories = <String>{};

  Set<String> get favoritedStories => Set.unmodifiable(_favoritedStories);

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

  void addFavorite(String storyId) {
    _favoritedStories.add(storyId);
    notifyListeners();
  }

  void removeFavorite(String storyId) {
    _favoritedStories.remove(storyId);
    notifyListeners();
  }

  // Sync with HomeProvider
  void syncWithHomeProvider(Set<String> homeFavorites) {
    _favoritedStories.clear();
    _favoritedStories.addAll(homeFavorites);
    notifyListeners();
  }
}
