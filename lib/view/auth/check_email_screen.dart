import 'package:flutter/material.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/widgets/common/custom_app_bar.dart';
import 'package:storifuel/widgets/common/round_button.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: context.screenHeight * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAppBar(),
                const SizedBox(height: 150),
                Image.asset(
                  AppImages.emailIcon,
                  height: 297,
                  width: 327,
                ),
                const SizedBox(height: 130),
                RoundButton(text: "Sign In", onPressed: () {
                  Navigator.pushNamed(context, '/sign-in');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}