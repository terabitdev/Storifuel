import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/services/firebase/story_service.dart';
import 'package:storifuel/widgets/story_details/story_options_popup.dart';

class StoryDetailsScreen extends StatelessWidget {
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
            (story) => story.id == storyId,
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
                            child: image.startsWith('http')
                                ? Image.network(
                                    image,
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
                                      return Image.asset(
                                        AppImages.story,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(image, fit: BoxFit.cover),
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
                                        storyId,
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
                                      onEdit: () {},
                                      onExportPDF: () {},
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
                              title,
                              style: poppins22w600.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  category,
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
                                  timeAgo,
                                  style: poppins14w400.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              content,
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
              // Bottom Share Button\
            ],
          );
        },
      ),
    );
  }
}
