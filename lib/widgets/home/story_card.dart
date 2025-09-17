import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/models/story_model.dart';
import 'package:storifuel/routes/routes_name.dart';
import 'package:storifuel/services/firebase/story_service.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;

  const StoryCard({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutesName.storyDetails,
          arguments: {
            'storyId': story.id,
            'image': story.imageUrl ?? AppImages.story,
            'title': story.title,
            'categories': story.categories,
            'timeAgo': story.getTimeAgo(),
            'tags': story.categories.map((cat) => '#${cat.toLowerCase()}').toList(),
            'content': story.description,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // ✅ Image with Fav Icon overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: story.imageUrl != null
                    ? Image.network(
                        story.imageUrl!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 160,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildNoImagePlaceholder();
                        },
                      )
                    : _buildNoImagePlaceholder(),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      await StoryService().toggleFavorite(story.id);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating favorite: $e')),
                      );
                    }
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      story.isFavorited ? AppImages.favIcon : AppImages.nonFavIcon,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ✅ Text Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        story.title,
                        style: nunitoSans18w700,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppImages.clockIcon,
                            height: 14,
                            width: 14,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            story.getTimeAgo(),
                            style: nunito12w400.copyWith(color: Colors.white, fontSize: 10,fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  story.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: nunito12w400.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    ));
  }

Widget _buildNoImagePlaceholder() { return Container( height: 160, width: double.infinity, color: Colors.grey[100], child: Column( mainAxisAlignment: MainAxisAlignment.center, children: [ Icon( Icons.image_not_supported_outlined, size: 40, color: Colors.grey[400], ), const SizedBox(height: 8), Text( 'No Image Uploaded', style: nunito12w400.copyWith( color: Colors.grey[500], fontSize: 14, ), ), ], ), ); } }