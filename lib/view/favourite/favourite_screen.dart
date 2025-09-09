import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/routes/routes_name.dart';
import 'package:storifuel/view_model/favourite/favourite_provider.dart';
import 'package:storifuel/view_model/home/home_provider.dart';
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
              Text("Favourite", style: poppins18w600),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer2<FavouriteProvider, HomeProvider>(
                  builder: (context, favouriteProvider, homeProvider, _) {
                    final allStories = homeProvider.allStories;
                    
                    // Filter stories to show only favorited ones
                    final favoritedStories = allStories
                        .where((story) => favouriteProvider.isStoryFavorited(story.id))
                        .toList();

                    if (favoritedStories.isEmpty) {
                      return _buildEmptyState();
                    }

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
