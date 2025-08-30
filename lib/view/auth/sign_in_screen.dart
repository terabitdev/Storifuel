import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/core/utils/toast.dart';
import 'package:storifuel/view_model/Auth/auth_provider.dart';
import 'package:storifuel/widgets/auth/custom_textfield.dart';
import 'package:storifuel/widgets/common/auth_redirect_text.dart';
import 'package:storifuel/widgets/common/round_button.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    
    // Validate remember me checkbox if required
    if (!authProvider.rememberMe) {
      showErrorToast(context, 'Please check "Remember Me" to continue');
      return;
    }

    final success = await authProvider.signIn(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (success) {
      if (mounted) {
        // Wait for auth state to update
        await Future.delayed(const Duration(milliseconds: 500));
        final user = authProvider.currentUser;
        // ignore: use_build_context_synchronously
        showSuccessToast(context, user != null 
            ? 'Welcome back, ${user.email}!' 
            : 'Welcome back!');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/navbar');
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

    return Scaffold(
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
                  Text("Sign In", style: poppins29w600),
                  const SizedBox(height: 60),
                  CustomTextField(
                    labelText: "EMAIL",
                    controller: emailController,
                    focusNode: emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
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
                          GestureDetector(
                            onTap: () {
                              authProvider.toggleRememberMe(!authProvider.rememberMe);
                            },
                            child: Text("Remember Me *", style: outfit12w400),
                          ),
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
                    text: authProvider.isLoading ? "Signing in..." : "Sign In",
                    isLoading: authProvider.isLoading,
                    onPressed: authProvider.isLoading ? null : handleSignIn,
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
      ),
    );
  }
}
