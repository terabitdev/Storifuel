import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback? onPressed;
  
  const ShareButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Share',
              style: poppins16w600.copyWith(color: Colors.white),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              AppImages.shareIcon,
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}