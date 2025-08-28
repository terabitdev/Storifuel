import 'package:flutter/material.dart';

class StoryProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController storyController = TextEditingController();

  String? selectedCategory;
  final List<String> availableCategories = <String>[
    'Business',
    'Crypto',
    'Technology',
  ];

  void selectCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  void clear() {
    titleController.clear();
    storyController.clear();
    selectedCategory = null;
    notifyListeners();
  }

  void addCategory(String category) {
    final String trimmed = category.trim();
    if (trimmed.isEmpty) return;
    if (!availableCategories.contains(trimmed)) {
      availableCategories.add(trimmed);
      notifyListeners();
    }
  }
}


