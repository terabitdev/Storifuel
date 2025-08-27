import 'package:flutter/material.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class AuthRedirectText extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback onTap;

  const AuthRedirectText({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          leadingText,
          style: outfit14w400, 
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: outfit14w500, 
          ),
        ),
      ],
    );
  }
}
