import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/widgets/home/search_field.dart';
import 'package:storifuel/widgets/home/story_card.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: secondaryColor,
        onPressed: () {},
        child: SvgPicture.asset(AppImages.plusIcon),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: context.screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset(AppImages.logo1, width: 118, height: 32)),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  text: "Power ",
                  style: poppins22w600.copyWith(color: secondaryColor),
                  children: [
                    TextSpan(
                      text: "confidence with your stories",
                      style: poppins22w600.copyWith(color: Colors.black),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SearchWidget(controller: searchController),
              const SizedBox(height: 20),
              Text("Recently", style: poppins18w600),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: const [
                    StoryCard(
                      image: AppImages.story,
                      title: "Bitcoin Bull Run ‘May Not Happen Until 2025",
                      description:
                          "Bitcoin is a crypto asset that is a reference for various altcoins that have currently been launched, so its price movements are an important...",
                      timeAgo: "3h ago",
                    ),
                    StoryCard(
                      image: AppImages.story,
                      title: "An Evening Walk Under the Gentle Rain",
                      description:
                          "Last night, I went out for a walk while the rain gently poured down. The streets were quiet, and the sound of raindrops on the rooftops made everything feel peaceful...",
                      timeAgo: "3h ago",
                    ),
                    StoryCard(
                      image: AppImages.story,
                      title: "My Daughter’s First Day at School",
                      description:
                          "The day started with a mix of joy and nervousness as I held my daughter’s tiny hand and walked her into her classroom...",
                      timeAgo: "3h ago",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
