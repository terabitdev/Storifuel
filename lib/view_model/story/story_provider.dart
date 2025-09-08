import 'package:flutter/material.dart';
import 'dart:io';

class StoryProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController storyController = TextEditingController();

  String? selectedCategory;
  File? selectedImage;
  bool isListening = false;
  final List<String> availableCategories = <String>[
    'Business',
    'Crypto',
    'Technology',
  ];

  void selectCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSelectedImage(File? image) {
    selectedImage = image;
    notifyListeners();
  }

  void setListening(bool listening) {
    isListening = listening;
    notifyListeners();
  }

  void appendToStory(String text) {
    String currentText = storyController.text;
    String newText = currentText.isEmpty ? text : '$currentText $text';
    storyController.text = newText;
    notifyListeners();
  }

  void clear() {
    titleController.clear();
    storyController.clear();
    selectedCategory = null;
    selectedImage = null;
    isListening = false;
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


