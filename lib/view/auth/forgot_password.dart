import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/core/utils/toast.dart';
import 'package:storifuel/view_model/Auth/auth_provider.dart';
import 'package:storifuel/widgets/auth/custom_textfield.dart';
import 'package:storifuel/widgets/common/custom_app_bar.dart';
import 'package:storifuel/widgets/common/round_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  void _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final email = emailController.text.trim();

    final success = await authProvider.resetPassword(email);

    if (success) {
      if (mounted) {
        showSuccessToast(context, 'Reset link sent to $email');
        Navigator.pushNamed(context, '/check-email', arguments: {'email': email});
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: context.screenHeight * 0.03),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAppBar(),
                const SizedBox(height: 90),
                Text("Forgot Password", style: nunitoSans24w700),
                const SizedBox(height: 50),
                CustomTextField(
                  labelText: "Email",
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
                    _handleForgotPassword();
                  },
                ),
                const SizedBox(height: 20),
                Text('Please enter your email, we will send you',style: nunitoSans16w400),
                Text('a link to reset your password',style: nunitoSans16w400),
                const Spacer(),
                RoundButton(
                  text: authProvider.isLoading ? "Sending..." : "Send Link",
                  isLoading: authProvider.isLoading,
                  onPressed: authProvider.isLoading ? null : _handleForgotPassword,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}