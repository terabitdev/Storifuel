import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/models/story_model.dart';
import 'package:storifuel/routes/routes_name.dart';
import 'package:storifuel/view_model/home/home_provider.dart';
import 'package:storifuel/widgets/common/round_button.dart';
import 'package:storifuel/widgets/home/empty_state_widget.dart';
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
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.createStory);
        },
        child: SvgPicture.asset(AppImages.plusIcon),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: context.screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(AppImages.logo1, width: 118, height: 32),
              ),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  text: "Power ",
                  style: poppins22w600.copyWith(color: secondaryColor),
                  children: [
                    TextSpan(
                      text: "confidence with your stories",
                      style: poppins22w600.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SearchWidget(
                controller: searchController,
                onFilterTap: () => _showFilterBottomSheet(context),
              ),
              const SizedBox(height: 20),
              Text("Recently", style: poppins18w600),
              const SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<List<StoryModel>>(
                  stream: context.read<HomeProvider>().getStoriesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    
                    final stories = snapshot.data ?? [];
                    context.read<HomeProvider>().updateStories(stories);
                    
                    if (stories.isEmpty) {
                      return EmptyStateWidget(
                        title: 'No Stories Yet',
                        description: 'Start sharing your thoughts and experiences by creating your first story!',
                        actionText: 'Create Story',
                        onAction: () {
                          Navigator.pushNamed(context, RoutesName.createStory);
                        },
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        return StoryCard(story: stories[index]);
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

  void _showFilterBottomSheet(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ChangeNotifierProvider<HomeProvider>.value(
          value: homeProvider,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Consumer<HomeProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 56,
                          height: 6,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Filter Categories',
                          style: nunitoSans16w700.copyWith(
                            color: const Color(0xFF0F182E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(AppImages.searchIcon),
                            ),
                            hintText: "Search categories",
                            hintStyle: outfit14w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...provider.availableCategories.map(
                        (category) => _FilterCategoryRow(
                          category: category,
                          isSelected: provider.isCategorySelected(category),
                          onTap: () => provider.toggleCategory(category),
                        ),
                      ),
                      const SizedBox(height: 24),
                      RoundButton(
                        text: 'Search',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _FilterCategoryRow extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterCategoryRow({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category,
                  style: nunitoSans16w700.copyWith(
                    color: const Color(0xFF0F182E),
                  ),
                ),
              ),
              _FilterCheckIcon(isSelected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterCheckIcon extends StatelessWidget {
  final bool isSelected;
  const _FilterCheckIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF35B34A) : const Color(0xFFE0E0E0),
          width: 2,
        ),
        color: isSelected ? const Color(0xFF35B34A) : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}
