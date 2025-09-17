import 'package:flutter/material.dart';
import 'dart:io';
import 'package:storifuel/models/story_model.dart';
import 'package:storifuel/services/firebase/story_service.dart';

class StoryProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController storyController = TextEditingController();
  final FocusNode storyFocusNode = FocusNode();
  final StoryService _storyService = StoryService();

  List<String> selectedCategories = [];
  File? selectedImage;
  String? existingImageUrl; // For edit mode - tracks the current image URL
  bool isListening = false;
  bool isPublishing = false;
  final List<String> availableCategories = <String>[
    'Business',
    'Crypto',
    'Technology',
  ];

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    notifyListeners();
  }

  void selectCategory(String category) {
    if (!selectedCategories.contains(category)) {
      selectedCategories.add(category);
      notifyListeners();
    }
  }

  bool isCategorySelected(String category) {
    return selectedCategories.contains(category);
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

  void dismissKeyboard() {
    storyFocusNode.unfocus();
  }

  void clear() {
    titleController.clear();
    storyController.clear();
    selectedCategories.clear();
    selectedImage = null;
    existingImageUrl = null;
    isListening = false;
    isPublishing = false;
    notifyListeners();
  }

  // Initialize provider for edit mode
  void initializeForEdit(StoryModel? story) {
    if (story != null) {
      titleController.text = story.title;
      storyController.text = story.description;
      selectedCategories = List<String>.from(story.categories);
      existingImageUrl = story.imageUrl;
      
      // Add categories to available categories if they don't exist
      for (String category in story.categories) {
        if (category.isNotEmpty && !availableCategories.contains(category)) {
          availableCategories.add(category);
        }
      }
      
      notifyListeners();
    }
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
    if (selectedCategories.isEmpty) {
      return 'Please select at least one category';
    }
    return null;
  }

  // Publish story
  Future<bool> publishStory() async {
    try {
      // print('Starting publishStory...');
      final validation = validateStory();
      if (validation != null) {
        // print('Validation failed: $validation');
        throw Exception(validation);
      }

      // print('Setting publishing state to true...');
      isPublishing = true;
      notifyListeners();

      // print('Calling story service...');
      await _storyService.createStory(
        title: titleController.text.trim(),
        description: storyController.text.trim(),
        categories: selectedCategories,
        imageFile: selectedImage,
      );

      // print('Story service completed. Setting publishing to false...');
      // Set publishing to false before clearing
      isPublishing = false;
      notifyListeners();
      
      // print('publishStory completed successfully!');
      return true;
    } catch (e) {
      // print('Error in publishStory: $e');
      isPublishing = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update existing story
  Future<bool> updateStory(String storyId) async {
    try {
      // print('Starting updateStory...');
      final validation = validateStory();
      if (validation != null) {
        // print('Validation failed: $validation');
        throw Exception(validation);
      }

      // print('Setting publishing state to true...');
      isPublishing = true;
      notifyListeners();

      // print('Calling story service update...');
      await _storyService.updateStory(
        storyId,
        title: titleController.text.trim(),
        description: storyController.text.trim(),
        categories: selectedCategories,
        imageFile: selectedImage, // This will replace the image if a new one is selected
      );

      // print('Story service update completed. Setting publishing to false...');
      isPublishing = false;
      notifyListeners();
      
      // print('updateStory completed successfully!');
      return true;
    } catch (e) {
      // print('Error in updateStory: $e');
      isPublishing = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    storyController.dispose();
    storyFocusNode.dispose();
    super.dispose();
  }
}


