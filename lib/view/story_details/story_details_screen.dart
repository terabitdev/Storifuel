import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/utils/toast.dart';
import 'package:storifuel/models/story_model.dart';
import 'package:storifuel/services/firebase/story_service.dart';
import 'package:storifuel/services/pdf/pdf_service.dart';
import 'package:storifuel/view/story/create_story_screen.dart';
import 'package:storifuel/widgets/common/no_image_placeholder.dart';
import 'package:storifuel/widgets/common/pdf_progress_dialog.dart';
import 'package:storifuel/widgets/common/share_button.dart';
import 'package:storifuel/widgets/story_details/story_options_popup.dart';

class StoryDetailsScreen extends StatefulWidget {
  final String storyId;
  final String image;
  final String title;
  final String category;
  final String timeAgo;
  final List<String> tags;
  final String content;

  const StoryDetailsScreen({
    super.key,
    required this.storyId,
    required this.image,
    required this.title,
    required this.category,
    required this.timeAgo,
    required this.tags,
    required this.content,
  });

  @override
  State<StoryDetailsScreen> createState() => _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends State<StoryDetailsScreen> {
  
  /// Navigate to edit story screen
  void _navigateToEditStory(BuildContext context, StoryModel story) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateStoryScreen(storyToEdit: story),
      ),
    );
  }
  
  /// Shares the story as PDF
  Future<void> _shareStoryAsPDF(BuildContext context, StoryModel story) async {
    try {
      // Show progress dialog
      PDFProgressDialog.show(
        context, 
        message: 'Preparing story for sharing...',
      );

      // Generate the PDF
      final String? filePath = await PDFService.generateStoryPDF(story);
      
      // Hide progress dialog
      // ignore: use_build_context_synchronously
      PDFProgressDialog.hide(context);

      if (filePath != null) {
        // Share the PDF file
        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'Check out this story: ${story.title}',
        );
      } else {
        // Show error toast
        // ignore: use_build_context_synchronously
        showErrorToast(context, 'Failed to generate PDF for sharing');
      }
    } catch (e) {
      // Hide progress dialog if still showing
      // ignore: use_build_context_synchronously
      PDFProgressDialog.hide(context);
      
      // Show error toast
      // ignore: use_build_context_synchronously
      showErrorToast(context, 'Error sharing story: $e');
      print(e);
    }
  }
  
  /// Exports the story to PDF with progress dialog
  Future<void> _exportToPDF(BuildContext context, StoryModel story) async {
    try {
      // Show progress dialog
      PDFProgressDialog.show(
        context, 
        message: 'Preparing your story...',
      );

      // Simulate some initial processing time
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Update progress
      PDFProgressDialog.update(
        // ignore: use_build_context_synchronously
        context, 
        message: 'Generating PDF document...',
      );

      // Generate the PDF
      final String? filePath = await PDFService.generateStoryPDF(story);
      
      // Hide progress dialog
      // ignore: use_build_context_synchronously
      PDFProgressDialog.hide(context);

      if (filePath != null) {
        // Show success toast
        // ignore: use_build_context_synchronously
        print(filePath);
        showSuccessToast(context, 'PDF Generated Successfully!');
      } else {
        // Show error toast
        // ignore: use_build_context_synchronously
        showErrorToast(context, 'PDF Generation Failed', );
      }
    } catch (e) {
      // Hide progress dialog if still showing
      // ignore: use_build_context_synchronously
      PDFProgressDialog.hide(context);
      
      // Show error toast
      // ignore: use_build_context_synchronously
      showErrorToast(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: StoryService().getStories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stories = snapshot.data ?? [];
          final currentStory = stories.firstWhere(
            (story) => story.id == widget.storyId,
            orElse: () => throw Exception('Story not found'),
          );

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: double.infinity,
                            child: currentStory.imageUrl != null && currentStory.imageUrl!.isNotEmpty
                                ? Image.network(
                                    currentStory.imageUrl!,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const NoImagePlaceholder();
                                    },
                                  )
                                : const NoImagePlaceholder(),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 10,
                            left: 16,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset(
                                AppImages.arrowIcon,
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                          // Top right icons
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 10,
                            right: 16,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    try {
                                      await StoryService().toggleFavorite(
                                        widget.storyId,
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error updating favorite: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    currentStory.isFavorited
                                        ? AppImages.favIcon
                                        : AppImages.nonFavIcon,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    StoryOptionsPopup.show(
                                      context,
                                      onEdit: () => _navigateToEditStory(context, currentStory),
                                      onExportPDF: () => _exportToPDF(context, currentStory),
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    AppImages.drawerIcon,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              widget.title,
                              style: poppins22w600.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  currentStory.category,
                                  style: nunito14w500.copyWith(
                                    color: const Color(0xFF4CAF50),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '•',
                                  style: poppins14w400.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.timeAgo,
                                  style: poppins14w400.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              widget.content,
                              style: nunito14w500.copyWith(
                                color: Colors.black87,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ShareButton(onPressed: () => _shareStoryAsPDF(context, currentStory)),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
