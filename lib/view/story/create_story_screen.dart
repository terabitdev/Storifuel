import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/view_model/story/story_provider.dart';
import 'package:storifuel/widgets/common/round_button.dart';
import 'package:storifuel/widgets/story/category_picker.dart';
import 'package:storifuel/widgets/story/media_uploader.dart';
import 'package:storifuel/widgets/story/story_field.dart';
import 'package:storifuel/widgets/story/title_field.dart';
import 'package:storifuel/widgets/story/voice_button.dart';

class CreateStoryScreen extends StatelessWidget {
  const CreateStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoryProvider(),
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
              title: Text('Create New Story', style: nunitoSans18w700.copyWith(color: const Color(0xFF0F182E))),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MediaUploader(onTap: () {}),
                    const SizedBox(height: 20),
                    TitleField(controller: provider.titleController),
                    const SizedBox(height: 20),
                    StoryField(controller: provider.storyController),
                    const SizedBox(height: 16),
                    const VoiceButton(),
                    const SizedBox(height: 24),
                    const CategoryPicker(),
                    const SizedBox(height: 28),
                    RoundButton(text: 'Publish', onPressed: () {}),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}