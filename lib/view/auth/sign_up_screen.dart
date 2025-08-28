import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/view_model/Auth/auth_provider.dart';
import 'package:storifuel/widgets/auth/custom_textfield.dart';
import 'package:storifuel/widgets/common/auth_redirect_text.dart';
import 'package:storifuel/widgets/common/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: context.screenHeight * 0.03,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppImages.logo1, width: 118, height: 32),
                const SizedBox(height: 90),
                Text("Sign Up", style: poppins29w600),
                const SizedBox(height: 60),
                CustomTextField(labelText: "FULL NAME", controller: fullNameController),
                const SizedBox(height: 37),
                CustomTextField(labelText: "EMAIL", controller: emailController),
                const SizedBox(height: 37),
                CustomTextField(
                  obscureText: !authProvider.isPasswordVisible,
                  labelText: "PASSWORD",
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      authProvider.togglePasswordVisibility();
                    },
                    icon: SvgPicture.asset(
                      height: 20,
                      width: 20,
                      authProvider.isPasswordVisible
                          ? AppImages.eyeOpenIcon
                          : AppImages.eyeClosedIcon,
                    ),
                  ),
                ),
                const SizedBox(height: 27),
                RoundButton(
                  text: "Sign Up",
                  onPressed: () {
                    // handle sign up
                  },
                ),
                SizedBox(height: 190),
                AuthRedirectText(
                  leadingText: "Already have an account?",
                  actionText: "Sign in",
                  onTap: () {
                    Navigator.pushNamed(context, '/sign-in');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}