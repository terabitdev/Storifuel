import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? selectedImage;
  final Function(File?)? onImageSelected;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.selectedImage,
    this.onImageSelected,
    this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePickerOptions(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: const Color(0xFFE0E7FF),
            backgroundImage: _getImageProvider(),
            child: _getImageProvider() == null
                ? Icon(
                    Icons.person,
                    size: radius * 0.8,
                    color: Colors.grey.shade600,
                  )
                : null,
          ),
          Positioned(
            right: 4,
            bottom: 2,
            child: Image.asset(
              AppImages.imageEditIcon,
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    if (selectedImage != null) {
      return FileImage(selectedImage!);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return null;
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 6,
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Update Profile Picture',
              style: outfit16w500.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildOptionTile(
                    context: context,
                    icon: Icons.photo_library,
                    title: 'Choose from Gallery',
                    onTap: () => _pickImage(context, ImageSource.gallery),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionTile(
                    context: context,
                    icon: Icons.camera_alt,
                    title: 'Take Photo',
                    onTap: () => _pickImage(context, ImageSource.camera),
                  ),
                  if (imageUrl != null || selectedImage != null) ...[
                    const SizedBox(height: 16),
                    _buildOptionTile(
                      context: context,
                      icon: Icons.delete_outline,
                      title: 'Remove Photo',
                      onTap: () => _removeImage(context),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: secondaryColor, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: outfit16w500.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(BuildContext context, ImageSource source) async {
    Navigator.pop(context);
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image != null) {
        onImageSelected?.call(File(image.path));
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _removeImage(BuildContext context) {
    Navigator.pop(context);
    onImageSelected?.call(null);
  }
}