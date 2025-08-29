import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/widgets/common/share_button.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(AppImages.arrowIcon, height: 25, width: 25),
                  ),
                ),
                // Top right icons
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 16,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.favIcon,
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          StoryOptionsPopup.show(
                            context,
                            onEdit: () {
                            },
                            onExportPDF: () {
                            },
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
                    style: poppins22w600.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        category,
                        style: nunito14w500.copyWith(color: const Color(0xFF4CAF50)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: poppins14w400.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeAgo,
                        style: poppins14w400.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Popular Tags',
                    style: poppins16w600.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tag,
                        style: nunito14w500.copyWith(color: Colors.grey.shade600),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    content,
                    style: nunito14w500.copyWith(
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 100),
                  ShareButton(onPressed: () {
                    // Handle share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Share functionality would be implemented here'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    
    );
  }
}