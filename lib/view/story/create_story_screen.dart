import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/utils/toast.dart';
import 'package:storifuel/models/story_model.dart';
import 'package:storifuel/view_model/story/story_provider.dart';
import 'package:storifuel/widgets/common/round_button.dart';
import 'package:storifuel/widgets/story/category_picker.dart';
import 'package:storifuel/widgets/story/media_uploader.dart';
import 'package:storifuel/widgets/story/story_field.dart';
import 'package:storifuel/widgets/story/title_field.dart';
import 'package:storifuel/widgets/story/voice_button.dart';

class CreateStoryScreen extends StatelessWidget {
  final StoryModel? storyToEdit;
  
  const CreateStoryScreen({super.key, this.storyToEdit});

  @override
  Widget build(BuildContext context) {
    final isEditMode = storyToEdit != null;
    
    return ChangeNotifierProvider(
      create: (_) => StoryProvider()..initializeForEdit(storyToEdit),
      child: Builder(
        builder: (context) {
          final provider = Provider.of<StoryProvider>(context, listen: false);
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              elevation: 0,
              backgroundColor: primaryColor,
              leading: IconButton(
                icon: Image.asset(AppImages.backIcon, width: 24, height: 24),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(
                isEditMode ? 'Edit Story' : 'Create New Story', 
                style: nunitoSans18w700.copyWith(color: const Color(0xFF0F182E))
              ),
            ),
            body: SafeArea(
              child: GestureDetector(
                onTap: () {
                  // Dismiss keyboard when tapping outside text fields
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MediaUploader(
                      onImageSelected: (image) => provider.setSelectedImage(image),
                      existingImageUrl: provider.existingImageUrl,
                    ),
                    const SizedBox(height: 20),
                    TitleField(controller: provider.titleController),
                    const SizedBox(height: 20),
                    StoryField(
                      controller: provider.storyController,
                      focusNode: provider.storyFocusNode,
                    ),
                    const SizedBox(height: 16),
                    const VoiceButton(),
                    const SizedBox(height: 24),
                    const CategoryPicker(),
                    const SizedBox(height: 28),
                    Consumer<StoryProvider>(
                      builder: (context, provider, _) {
                        return RoundButton(
                          text: isEditMode ? 'Update Story' : 'Publish',
                          isLoading: provider.isPublishing,
                          onPressed: provider.isPublishing
                              ? null
                              : () => isEditMode 
                                  ? _updateStory(context, provider)
                                  : _publishStory(context, provider),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _publishStory(BuildContext context, StoryProvider provider) async {
    try {
      final success = await provider.publishStory();
      if (success && context.mounted) {
        showSuccessToast(context, 'Story published successfully!');
        // Clear the form after successful navigation
        provider.clear();
        Navigator.pop(context); // Navigate back to previous screen (likely home)
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(context, 'Failed to publish story: $e');
      }
    }
  }

  Future<void> _updateStory(BuildContext context, StoryProvider provider) async {
    try {
      final success = await provider.updateStory(storyToEdit!.id);
      if (success && context.mounted) {
        showSuccessToast(context, 'Story updated successfully!');
        Navigator.pop(context); // Navigate back to story details
        Navigator.pop(context); // Navigate back to previous screen (likely home)
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(context, 'Failed to update story: $e');
      }
    }
  }
}