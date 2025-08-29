import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/core/utils/toast.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.signUp(
      email: emailController.text.trim(),
      password: passwordController.text,
      fullName: fullNameController.text.trim(),
    );

    if (success) {
      if (mounted) {
        showSuccessToast(context, 'Account created successfully!');
        Navigator.pushReplacementNamed(context, '/sign-in');
      }
    } else {
      if (mounted && authProvider.errorMessage != null) {
        showErrorToast(context, authProvider.errorMessage!);
      }
    }
  }

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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logo1, width: 118, height: 32),
                  const SizedBox(height: 90),
                  Text("Sign Up", style: poppins29w600),
                  const SizedBox(height: 60),
                  CustomTextField(
                    labelText: "FULL NAME",
                    controller: fullNameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 37),
                  CustomTextField(
                    labelText: "EMAIL",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 37),
                  CustomTextField(
                    obscureText: !authProvider.isPasswordVisible,
                    labelText: "PASSWORD",
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
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
                  RoundButton(
                    text: authProvider.isLoading ? "Signing up..." : "Sign Up",
                    isLoading: authProvider.isLoading,
                    onPressed: authProvider.isLoading ? null : _handleSignUp,
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
      ),
    );
  }
}