import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:storifuel/models/story_model.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Get user's story document reference
  DocumentReference get _userStoriesDoc {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('stories').doc(currentUserId);
  }

  // Upload image to Firebase Storage
  Future<String?> _uploadImage(File imageFile, String storyId) async {
    try {
      // print('🔄 Starting image upload process...');
      
      // Check Firebase initialization
      try {
        await Firebase.initializeApp();
        // print('✅ Firebase app initialized/verified');
      } catch (e) {
        // print('⚠️ Firebase already initialized or initialization error: $e');
      }
      
      if (currentUserId == null) {
        // print('❌ No current user, cannot upload image');
        return null;
      }
      
      // print('✅ Current user ID: $currentUserId');
      // print('📁 Image file path: ${imageFile.path}');
      // print('📏 Image file size: ${await imageFile.length()} bytes');
      
      // Verify file exists and is readable
      if (!await imageFile.exists()) {
        // print('❌ Image file does not exist at path');
        return null;
      }
      
      final String fileName = '${storyId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = 'stories/$currentUserId/$fileName';
      
      // Create fresh storage instance to avoid channel issues
      final FirebaseStorage freshStorage = FirebaseStorage.instance;
      final Reference ref = freshStorage.ref().child(filePath);
      
      // print('📍 Storage reference path: $filePath');
      // print('🔄 Creating fresh storage reference...');
      // print('⬆️ Starting file upload...');
      
      final UploadTask uploadTask = ref.putFile(imageFile);
      // print('📤 Upload task created successfully');
      
      // Add progress listener to see if upload is actually progressing
      // uploadTask.snapshotEvents.listen((snapshot) {
      //   final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      //   print('📊 Upload progress: ${(progress * 100).toInt()}% (${snapshot.bytesTransferred}/${snapshot.totalBytes} bytes)');
      //   print('📈 Upload state: ${snapshot.state}');
      // });
      
      // print('⏳ Waiting for upload completion...');
      final TaskSnapshot snapshot = await uploadTask;
      
      // print('✅ Upload task completed!');
      // print('📊 Final state: ${snapshot.state}');
      // print('📈 Final bytes: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');

      // print('🔗 Getting download URL...');
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // print('🎉 Image upload complete! URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      // print('❌ Error uploading image: $e');
      // print('❌ Error type: ${e.runtimeType}');
      return null;
    }
  }


  // Create a new story
  Future<String> createStory({
    required String title,
    required String description,
    required String category,
    File? imageFile,
    String? voiceUrl,
  }) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final storyId = _firestore.collection('temp').doc().id;
      final now = DateTime.now();

      // Upload image if provided
      String? imageUrl;
      if (imageFile != null) {
        // print('🖼️ Image file provided, attempting upload...');
        imageUrl = await _uploadImage(imageFile, storyId);
        if (imageUrl != null) {
          // print('✅ Image upload successful, URL obtained');
        } else {
          // print('❌ Image upload failed, continuing without image');
        }
      } else {
        // print('ℹ️ No image file provided');
      }

      final story = StoryModel(
        id: storyId,
        title: title.trim(),
        description: description.trim(),
        category: category,
        imageUrl: imageUrl,
        voiceUrl: voiceUrl,
        createdAt: now,
        updatedAt: now,
      );

      await _userStoriesDoc.set({
        'stories': FieldValue.arrayUnion([story.toMap()]),
      }, SetOptions(merge: true));

      return storyId;
    } catch (e) {
      rethrow;
    }
  }

  // Get all stories for the current user
  Stream<List<StoryModel>> getStories() {
    try {
      if (currentUserId == null) {
        return Stream.value([]);
      }

      return _userStoriesDoc.snapshots().map((docSnapshot) {
        if (!docSnapshot.exists || docSnapshot.data() == null) {
          return <StoryModel>[];
        }

        final data = docSnapshot.data() as Map<String, dynamic>;
        final storiesArray = data['stories'] as List<dynamic>? ?? [];
        
        final stories = storiesArray
            .map((storyData) => StoryModel.fromMap(Map<String, dynamic>.from(storyData)))
            .toList();

        // Sort by creation date (newest first)
        stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return stories;
      });
    } catch (e) {
      return Stream.value([]);
    }
  }

  // Get stories as a one-time fetch
  Future<List<StoryModel>> getStoriesOnce() async {
    try {
      if (currentUserId == null) {
        return [];
      }

      final docSnapshot = await _userStoriesDoc.get();
      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return [];
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      final storiesArray = data['stories'] as List<dynamic>? ?? [];
      
      final stories = storiesArray
          .map((storyData) => StoryModel.fromMap(Map<String, dynamic>.from(storyData)))
          .toList();

      // Sort by creation date (newest first)
      stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return stories;
    } catch (e) {
      return [];
    }
  }

  // Update a story
  Future<void> updateStory(String storyId, {
    String? title,
    String? description,
    String? category,
    File? imageFile,
    String? voiceUrl,
  }) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final docSnapshot = await _userStoriesDoc.get();
      if (!docSnapshot.exists) return;

      final data = docSnapshot.data() as Map<String, dynamic>;
      final storiesArray = List<Map<String, dynamic>>.from(data['stories'] ?? []);

      final storyIndex = storiesArray.indexWhere((story) => story['id'] == storyId);
      if (storyIndex != -1) {
        final currentStory = StoryModel.fromMap(storiesArray[storyIndex]);
        
        // Upload new image if provided and delete old one
        String? imageUrl = currentStory.imageUrl;
        if (imageFile != null) {
          // Delete old image if it exists
          if (currentStory.imageUrl != null && currentStory.imageUrl!.isNotEmpty) {
            try {
              final oldRef = _storage.refFromURL(currentStory.imageUrl!);
              await oldRef.delete();
            } catch (e) {
              print('Error deleting old image: $e');
              // Continue even if deletion fails
            }
          }
          
          // Upload new image
          imageUrl = await _uploadImage(imageFile, storyId);
        }

        final updatedStory = currentStory.copyWith(
          title: title,
          description: description,
          category: category,
          imageUrl: imageUrl,
          voiceUrl: voiceUrl,
          updatedAt: DateTime.now(),
        );

        storiesArray[storyIndex] = updatedStory.toMap();

        await _userStoriesDoc.update({
          'stories': storiesArray,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  // Delete a story
  Future<void> deleteStory(String storyId) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final docSnapshot = await _userStoriesDoc.get();
      if (!docSnapshot.exists) return;

      final data = docSnapshot.data() as Map<String, dynamic>;
      final storiesArray = List<Map<String, dynamic>>.from(data['stories'] ?? []);

      // Find story to delete its image
      final storyToDelete = storiesArray.firstWhere(
        (story) => story['id'] == storyId,
        orElse: () => <String, dynamic>{},
      );

      // Delete image from storage if exists
      if (storyToDelete.isNotEmpty && storyToDelete['imageUrl'] != null) {
        try {
          final ref = _storage.refFromURL(storyToDelete['imageUrl']);
          await ref.delete();
        } catch (e) {
          print('Error deleting image: $e');
        }
      }

      // Remove story from array
      storiesArray.removeWhere((story) => story['id'] == storyId);

      await _userStoriesDoc.update({
        'stories': storiesArray,
      });
      
    } catch (e) {
      rethrow;
    }
  }

  // Get stories by category
  Future<List<StoryModel>> getStoriesByCategory(String category) async {
    final allStories = await getStoriesOnce();
    return allStories.where((story) => story.category == category).toList();
  }

  // Search stories
  Future<List<StoryModel>> searchStories(String query) async {
    final allStories = await getStoriesOnce();
    final lowercaseQuery = query.toLowerCase();
    
    return allStories.where((story) {
      return story.title.toLowerCase().contains(lowercaseQuery) ||
             story.description.toLowerCase().contains(lowercaseQuery) ||
             story.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Toggle favorite status for a story
  Future<void> toggleFavorite(String storyId) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final docSnapshot = await _userStoriesDoc.get();
      if (!docSnapshot.exists) return;

      final data = docSnapshot.data() as Map<String, dynamic>;
      final storiesArray = List<Map<String, dynamic>>.from(data['stories'] ?? []);

      final storyIndex = storiesArray.indexWhere((story) => story['id'] == storyId);
      if (storyIndex != -1) {
        final currentStory = StoryModel.fromMap(storiesArray[storyIndex]);
        
        // Toggle favorite status
        final updatedStory = currentStory.copyWith(
          isFavorited: !currentStory.isFavorited,
          updatedAt: DateTime.now(),
        );

        storiesArray[storyIndex] = updatedStory.toMap();

        await _userStoriesDoc.update({
          'stories': storiesArray,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get only favorited stories
  Future<List<StoryModel>> getFavoriteStories() async {
    final allStories = await getStoriesOnce();
    return allStories.where((story) => story.isFavorited).toList();
  }

  // Stream of only favorited stories
  Stream<List<StoryModel>> getFavoriteStoriesStream() {
    return getStories().map((stories) => 
      stories.where((story) => story.isFavorited).toList());
  }
}