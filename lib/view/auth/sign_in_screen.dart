import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/view_model/Auth/auth_provider.dart';
import 'package:storifuel/widgets/auth/custom_textfield.dart';
import 'package:storifuel/widgets/common/auth_redirect_text.dart';
import 'package:storifuel/widgets/common/round_button.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
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
                Text("Sign In", style: poppins29w600),
                const SizedBox(height: 60),
                CustomTextField(
                  labelText: "EMAIL",
                  controller: emailController,
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: () {
                    passwordFocusNode.requestFocus(); 
                  },
                ),
                const SizedBox(height: 37),
                CustomTextField(
                  labelText: "PASSWORD",
                  controller: passwordController,
                  obscureText: !authProvider.isPasswordVisible,
                  focusNode: passwordFocusNode,
                  keyboardType: TextInputType.visiblePassword,
                  onSubmitted: () {
                  },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          value: authProvider.rememberMe,
                          onChanged: (val) {
                            authProvider.toggleRememberMe(val ?? false);
                          },
                        ),
                        Text("Remember Me", style: outfit12w400),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      child: Text("Forgot Password?", style: outfit12w4001),
                    ),
                  ],
                ),
                const SizedBox(height: 27),
                RoundButton(
                  text: "Sign In",
                  onPressed: () {
                    Navigator.pushNamed(context, '/navbar');
                  },
                ),
                SizedBox(height: 190),
                AuthRedirectText(
                  leadingText: "No account yet? ",
                  actionText: "Sign up now!",
                  onTap: () {
                    Navigator.pushNamed(context, '/sign-up');
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
