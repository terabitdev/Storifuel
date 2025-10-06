import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/models/story_model.dart';
import 'package:storifuel/routes/routes_name.dart';
import 'package:storifuel/services/firebase/story_service.dart';
import 'package:storifuel/widgets/home/story_card.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: secondaryColor,
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.createStory);
        },
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
              Text("Library", style: poppins18w600),
              const SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<List<StoryModel>>(
                  stream: StoryService().getFavoriteStoriesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    
                    final favoritedStories = snapshot.data ?? [];

                    if (favoritedStories.isEmpty) {
                      return _buildEmptyState();
                    }

                    // ✅ Sort alphabetically by title (A to Z)
      favoritedStories.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );

                    return ListView.builder(
                      itemCount: favoritedStories.length,
                      itemBuilder: (context, index) {
                        return StoryCard(story: favoritedStories[index]);
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
          ),
          const SizedBox(height: 16),
          Text(
            'No Favorite Stories Yet',
            style: nunitoSans18w700.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding stories to your favorites\nby tapping the heart icon',
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
