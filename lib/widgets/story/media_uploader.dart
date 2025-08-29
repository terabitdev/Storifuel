import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

class MediaUploader extends StatelessWidget {
  final VoidCallback? onTap;

  const MediaUploader({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(radius: const Radius.circular(12),
        color: Colors.grey, // ✅ Dotted border color
        strokeWidth: 1.5,
        dashPattern: const [6, 3], // ✅ 6px line, 3px gap
        ),
        child: Container(
          height: 90,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppImages.uploadIcon, width: 28, height: 28),
                const SizedBox(height: 12),
                Text('Add Story Media', style: outfit14w400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



