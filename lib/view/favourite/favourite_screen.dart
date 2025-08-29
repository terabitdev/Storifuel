import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/view_model/favourite/favourite_provider.dart';
import 'package:storifuel/widgets/home/story_card.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for now (replace with API/Firebase later)
    final List<Map<String, String>> allStories = [
      {
        "id": "story_1",
        "image": AppImages.story,
        "title": "Bitcoin Bull Run 'May Not Happen Until 2025",
        "description":
            "Bitcoin is a crypto asset that is a reference for various altcoins that have currently been launched, so its price movements are an important...",
        "timeAgo": "3h ago"
      },
      {
        "id": "story_2",
        "image": AppImages.story,
        "title": "An Evening Walk Under the Gentle Rain",
        "description":
            "Last night, I went out for a walk while the rain gently poured down. The streets were quiet, and the sound of raindrops on the rooftops made everything feel peaceful...",
        "timeAgo": "3h ago"
      },
      {
        "id": "story_3",
        "image": AppImages.story,
        "title": "My Daughter's First Day at School",
        "description":
            "The day started with a mix of joy and nervousness as I held my daughter's tiny hand and walked her into her classroom...",
        "timeAgo": "3h ago"
      },
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: secondaryColor,
        onPressed: () {},
        child: SvgPicture.asset(AppImages.plusIcon),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: context.screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset(AppImages.logo1, width: 118, height: 32)),
              const SizedBox(height: 20),
              Text("Favourite", style: poppins18w600),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<FavouriteProvider>(
                  builder: (context, provider, _) {
                    // Filter stories to show only favorited ones
                    final favoritedStories = allStories
                        .where((story) => provider.isStoryFavorited(story["id"]!))
                        .toList();

                    if (favoritedStories.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      itemCount: favoritedStories.length,
                      itemBuilder: (context, index) {
                        final story = favoritedStories[index];
                        return StoryCard(
                          storyId: story["id"]!,
                          image: story["image"]!,
                          title: story["title"]!,
                          description: story["description"]!,
                          timeAgo: story["timeAgo"]!,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppImages.nonFavIcon,
            width: 80,
            height: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Favourite Stories Yet',
            style: nunitoSans18w700.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding stories to your favourites\nby tapping the heart icon',
            textAlign: TextAlign.center,
            style: outfit14w400.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
