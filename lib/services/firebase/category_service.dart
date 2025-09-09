import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

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

      // Find and update the category
      final categoryIndex = categoriesArray.indexWhere((cat) => cat['id'] == categoryId);
      if (categoryIndex != -1) {
        categoriesArray[categoryIndex]['name'] = newName.trim();
        categoriesArray[categoryIndex]['updatedAt'] = Timestamp.now();

        // Update the entire array
        await _userCategoriesDoc.update({
          'categories': categoriesArray,
        });
      }
    } catch (e) {
      rethrow;
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

      // Remove the category with matching ID
      categoriesArray.removeWhere((cat) => cat['id'] == categoryId);

      // Update the array
      await _userCategoriesDoc.update({
        'categories': categoriesArray,
      });
      
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