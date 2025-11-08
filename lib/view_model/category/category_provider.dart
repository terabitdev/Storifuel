import 'dart:async';
import 'package:flutter/material.dart';
import 'package:storifuel/services/firebase/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<List<Map<String, dynamic>>>? _categoriesSubscription;

  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasCategories => _categories.isNotEmpty;

  // Helper method to sort categories alphabetically
  void _sortCategories() {
    _categories.sort((a, b) {
      final nameA = (a['name'] ?? '').toString().toLowerCase();
      final nameB = (b['name'] ?? '').toString().toLowerCase();
      return nameA.compareTo(nameB);
    });
  }

  CategoryProvider() {
    _initializeCategories();
  }

  void _initializeCategories() async {
    // First load categories synchronously to avoid empty state
    try {
      _categories = await _categoryService.getCategoriesOnce();
      _sortCategories();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load categories: $e';
    }

    // Then listen to real-time updates
    _categoriesSubscription = _categoryService.getCategories().listen(
      (categories) {
        _categories = categories;
        _sortCategories();
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Failed to load categories: $error';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Create a new category
  Future<bool> createCategory(String categoryName) async {
    if (categoryName.trim().isEmpty) {
      _setError('Category name cannot be empty');
      return false;
    }

    try {
      _setLoading(true);
      _setError(null);
      
      await _categoryService.createCategory(categoryName);
      return true;
    } catch (e) {
      _setError('Failed to create category: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing category
  Future<bool> updateCategory(String categoryId, String newName) async {
    if (newName.trim().isEmpty) {
      _setError('Category name cannot be empty');
      return false;
    }

    try {
      _setLoading(true);
      _setError(null);
      
      await _categoryService.updateCategory(categoryId, newName);
      return true;
    } catch (e) {
      _setError('Failed to update category: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete a category
  Future<bool> deleteCategory(String categoryId) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _categoryService.deleteCategory(categoryId);
      return true;
    } catch (e) {
      _setError('Failed to delete category: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get category name by ID
  String getCategoryName(String categoryId) {
    final category = _categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'name': 'Unknown'},
    );
    return category['name'] ?? 'Unknown';
  }

  // Check if category name already exists
  bool categoryExists(String categoryName) {
    return _categories.any(
      (cat) => cat['name'].toLowerCase() == categoryName.toLowerCase(),
    );
  }

  // Refresh categories manually
  Future<void> refreshCategories() async {
    try {
      _setLoading(true);
      _setError(null);

      final categories = await _categoryService.getCategoriesOnce();
      _categories = categories;
      _sortCategories();
    } catch (e) {
      _setError('Failed to refresh categories: $e');
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    _categoriesSubscription?.cancel();
    super.dispose();
  }
}