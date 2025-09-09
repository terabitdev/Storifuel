import 'package:flutter/material.dart';
import 'dart:io';
import 'package:storifuel/services/firebase/story_service.dart';

class StoryProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController storyController = TextEditingController();
  final StoryService _storyService = StoryService();

  String? selectedCategory;
  File? selectedImage;
  bool isListening = false;
  bool isPublishing = false;
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
    isPublishing = false;
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

  // Validate story data
  String? validateStory() {
    if (titleController.text.trim().isEmpty) {
      return 'Please enter a title';
    }
    if (storyController.text.trim().isEmpty) {
      return 'Please enter your story';
    }
    if (selectedCategory == null || selectedCategory!.trim().isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  // Publish story
  Future<bool> publishStory() async {
    try {
      print('Starting publishStory...');
      final validation = validateStory();
      if (validation != null) {
        print('Validation failed: $validation');
        throw Exception(validation);
      }

      print('Setting publishing state to true...');
      isPublishing = true;
      notifyListeners();

      print('Calling story service...');
      await _storyService.createStory(
        title: titleController.text.trim(),
        description: storyController.text.trim(),
        category: selectedCategory!,
        imageFile: selectedImage,
      );

      print('Story service completed. Setting publishing to false...');
      // Set publishing to false before clearing
      isPublishing = false;
      notifyListeners();
      
      print('publishStory completed successfully!');
      return true;
    } catch (e) {
      print('Error in publishStory: $e');
      isPublishing = false;
      notifyListeners();
      rethrow;
    }
  }
}


