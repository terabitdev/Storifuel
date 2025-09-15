import 'package:flutter/material.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class NoImagePlaceholder extends StatelessWidget {
  const NoImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'No Image Uploaded',
            style: nunito12w400.copyWith(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
