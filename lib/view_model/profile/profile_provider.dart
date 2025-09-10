import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:storifuel/services/firebase/auth_service.dart';

class ProfileProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  String? _profileImageUrl;
  File? _selectedImage;
  final bool _isLoading = false;
  bool _isUpdating = false;
  
  String? get profileImageUrl => _profileImageUrl;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  
  // Load user profile data
  Future<void> loadProfile() async {
    try {
      final userId = _authService.currentUserId;
      if (userId != null) {
        final userData = await _authService.getUserData(userId);
        
        if (userData != null) {
          nameController.text = userData['fullName'] ?? '';
          emailController.text = userData['email'] ?? '';
          _profileImageUrl = userData['profileImageUrl'];
          notifyListeners();
        }
      }
    } catch (e) {
      //
    }
  }
  
  // Set selected image
  void setSelectedImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }
  
  // Upload profile image to Firebase Storage
  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      final userId = _authService.currentUserId;
      if (userId == null) return null;
      
      final fileName = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('profile_images').child(fileName);
      
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      // Handle error if necessary
      return null;
    }
  }
  
  // Delete old profile image from Firebase Storage
  Future<void> _deleteOldProfileImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Continue even if deletion fails
    }
  }
  
  // Update profile
  Future<bool> updateProfile() async {
    try {
      _isUpdating = true;
      notifyListeners();
      
      final userId = _authService.currentUserId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      String? newImageUrl = _profileImageUrl;
      
      // Upload new image if selected
      if (_selectedImage != null) {
        // Delete old image if exists
        if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
          await _deleteOldProfileImage(_profileImageUrl!);
        }
        
        // Upload new image
        newImageUrl = await _uploadProfileImage(_selectedImage!);
        if (newImageUrl != null) {
          _profileImageUrl = newImageUrl;
        }
      }
      
      // Update user data in Firestore
      await _authService.updateUserData(userId, {
        'fullName': nameController.text.trim(),
        'profileImageUrl': newImageUrl,
      });
      
      // Clear selected image after successful update
      _selectedImage = null;
      return true;
    } catch (e) {
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}