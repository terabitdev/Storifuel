import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Get user's stories document reference
  DocumentReference get _userStoriesDoc {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('stories').doc(currentUserId);
  }

  // Get user's category document reference
  DocumentReference get _userCategoriesDoc {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('categories').doc(currentUserId);
  }

  // Create a new category
  Future<String> createCategory(String categoryName) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final categoryId = _firestore.collection('temp').doc().id; // Generate unique ID
      final now = Timestamp.now();
      final newCategory = {
        'id': categoryId,
        'name': categoryName.trim(),
        'createdAt': now,
        'updatedAt': now,
      };

      await _userCategoriesDoc.set({
        'categories': FieldValue.arrayUnion([newCategory]),
      }, SetOptions(merge: true));

      return categoryId;
    } catch (e) {
      rethrow;
    }
  }

  // Get all categories for the current user
  Stream<List<Map<String, dynamic>>> getCategories() {
    try {
      if (currentUserId == null) {
        return Stream.value([]);
      }

      return _userCategoriesDoc.snapshots().map((docSnapshot) {
        if (!docSnapshot.exists || docSnapshot.data() == null) {
          return <Map<String, dynamic>>[];
        }

        final data = docSnapshot.data() as Map<String, dynamic>;
        final categoriesArray = data['categories'] as List<dynamic>? ?? [];
        
        return categoriesArray
            .map((category) => Map<String, dynamic>.from(category))
            .toList();
      });
    } catch (e) {
      return Stream.value([]);
    }
  }

  // Update a category
  Future<void> updateCategory(String categoryId, String newName) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Get current categories
      final docSnapshot = await _userCategoriesDoc.get();
      if (!docSnapshot.exists) return;

      final data = docSnapshot.data() as Map<String, dynamic>;
      final categoriesArray = List<Map<String, dynamic>>.from(data['categories'] ?? []);

      // Find the category and get old name
      final categoryIndex = categoriesArray.indexWhere((cat) => cat['id'] == categoryId);
      if (categoryIndex != -1) {
        final oldName = categoriesArray[categoryIndex]['name'] as String;
        final trimmedNewName = newName.trim();
        
        // Update category name
        categoriesArray[categoryIndex]['name'] = trimmedNewName;
        categoriesArray[categoryIndex]['updatedAt'] = Timestamp.now();

        // Update the category array
        await _userCategoriesDoc.update({
          'categories': categoriesArray,
        });

        // Update all stories that use this category
        await _updateStoriesCategory(oldName, trimmedNewName);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to update all stories with a specific category
  Future<void> _updateStoriesCategory(String oldCategoryName, String newCategoryName) async {
    try {
      print('📝 Updating stories: "$oldCategoryName" → "$newCategoryName"');
      
      // Get user's stories
      final storiesDocSnapshot = await _userStoriesDoc.get();
      if (!storiesDocSnapshot.exists) {
        print('❌ No stories document found');
        return;
      }

      final storiesData = storiesDocSnapshot.data() as Map<String, dynamic>;
      final storiesArray = List<Map<String, dynamic>>.from(storiesData['stories'] ?? []);

      print('📚 Found ${storiesArray.length} stories to check');
      
      bool hasChanges = false;
      int updatedCount = 0;

      // Update stories that have the old category name
      for (int i = 0; i < storiesArray.length; i++) {
        final storyCategory = storiesArray[i]['category'];
        final storyTitle = storiesArray[i]['title'] ?? 'Untitled';
        print('📖 Story "$storyTitle" has category: "$storyCategory"');
        
        if (storyCategory == oldCategoryName) {
          print('🔄 Updating story: $storyTitle from "$oldCategoryName" to "$newCategoryName"');
          storiesArray[i]['category'] = newCategoryName;
          storiesArray[i]['updatedAt'] = DateTime.now();
          hasChanges = true;
          updatedCount++;
        }
      }

      print('✅ Updated $updatedCount stories');

      // Save updated stories if there were changes
      if (hasChanges) {
        await _userStoriesDoc.update({
          'stories': storiesArray,
        });
        print('💾 Stories saved to database');
      } else {
        print('ℹ️  No stories needed updating');
      }
    } catch (e) {
      print('❌ Error updating stories category: $e');
      // Don't rethrow - we don't want category update to fail if story update fails
    }
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      // Get current categories
      final docSnapshot = await _userCategoriesDoc.get();
      if (!docSnapshot.exists) return;

      final data = docSnapshot.data() as Map<String, dynamic>;
      final categoriesArray = List<Map<String, dynamic>>.from(data['categories'] ?? []);

      // Find the category to get its name before deleting
      final categoryToDelete = categoriesArray.firstWhere(
        (cat) => cat['id'] == categoryId,
        orElse: () => <String, dynamic>{},
      );

      if (categoryToDelete.isNotEmpty) {
        final categoryName = categoryToDelete['name'] as String;
        
        // Remove the category with matching ID
        categoriesArray.removeWhere((cat) => cat['id'] == categoryId);

        // Update the categories array
        await _userCategoriesDoc.update({
          'categories': categoriesArray,
        });

        // Update stories that had this category to have uncategorized
        await _updateStoriesCategory(categoryName, 'Uncategorized');
      }
      
    } catch (e) {
      rethrow;
    }
  }

  // Get categories as a one-time fetch (for dropdown/picker usage)
  Future<List<Map<String, dynamic>>> getCategoriesOnce() async {
    try {
      if (currentUserId == null) {
        return [];
      }

      final docSnapshot = await _userCategoriesDoc.get();
      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return [];
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      final categoriesArray = data['categories'] as List<dynamic>? ?? [];
      
      return categoriesArray
          .map((category) => Map<String, dynamic>.from(category))
          .toList();
    } catch (e) {
      return [];
    }
  }
}