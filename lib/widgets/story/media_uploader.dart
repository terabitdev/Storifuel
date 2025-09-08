import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MediaUploader extends StatefulWidget {
  final Function(File?)? onImageSelected;

  const MediaUploader({super.key, this.onImageSelected});

  @override
  State<MediaUploader> createState() => _MediaUploaderState();
}

class _MediaUploaderState extends State<MediaUploader> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImagePickerOptions,
      child: _selectedImage == null ? _buildUploadWidget() : _buildImageWidget(),
    );
  }

  Widget _buildUploadWidget() {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(12),
        color: Colors.grey,
        strokeWidth: 1.5,
        dashPattern: const [6, 3],
      ),
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppImages.uploadIcon, width: 28, height: 28),
              const SizedBox(height: 12),
              Text('Add Story Media', style: outfit14w400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: FileImage(_selectedImage!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.3),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: _showImagePickerOptions,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
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
              margin: EdgeInsets.only(top: 12, bottom: 24),
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Select Image Source',
              style: outfit16w500.copyWith(color: Colors.black),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildOptionTile(
                    icon: Icons.photo_library,
                    title: 'Gallery',
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                  SizedBox(height: 16),
                  _buildOptionTile(
                    icon: Icons.camera_alt,
                    title: 'Camera',
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
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

  void _pickImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        widget.onImageSelected?.call(_selectedImage);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}



