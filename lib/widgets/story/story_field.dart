import 'package:flutter/material.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class StoryField extends StatelessWidget {
  final TextEditingController controller;
  const StoryField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Story', style: nunitoSans16w400.copyWith(color: const Color(0xFF111827))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: 'Write something here…',
            hintStyle: outfit14w400,
            filled: true,
            fillColor: primaryColor,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: outlineInputColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: outlineInputColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}





