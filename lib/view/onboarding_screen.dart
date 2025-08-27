import 'package:flutter/material.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/widgets/common/auth_redirect_text.dart';
import 'package:storifuel/widgets/common/round_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          // Top Image Section with Logo Overlay
          SizedBox(
            height: context.screenHeight * 0.55, // 55% of screen height
            width: double.infinity,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    AppImages.onboarding,
                    fit: BoxFit.cover,
                  ),
                ),
                // Logo Overlay
                Positioned(
                  top: context.screenHeight * 0.08, // 8% from top
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Image
                      Image.asset(
                        AppImages.logo,
                        height: 39,
                        width: 147,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Content Section
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.06, // 6% of screen width
                vertical: context.screenHeight * 0.03, // 3% of screen height
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.screenWidth * 0.15), // Responsive border radius
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Main Heading
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.06),
                    child: Text(
                      "Find the right story for the right moment",
                      textAlign: TextAlign.center,
                      style: nunitoSans24w700,
                    ),
                  ),

                  // Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.03),
                    child: Text(
                      "Quickly search and access your stories whenever you need them.",
                      textAlign: TextAlign.center,
                      style: nunitoSans16w400,
                    ),
                  ),

                  // Join Now Button
                  RoundButton(
                    text: "Join Now",
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign-up');
                    },
                  ),
                 AuthRedirectText(leadingText: "Already have an account? ", actionText: "Sign In", onTap: () {
                   Navigator.pushNamed(context, '/sign-in');
                 })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}