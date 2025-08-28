import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class VoiceButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const VoiceButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: secondaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Voice to text', style: outfit16w500.copyWith(color: secondaryColor)),
            const SizedBox(width: 8),
            SvgPicture.asset(AppImages.voiceIcon, width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}


