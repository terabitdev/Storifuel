import 'package:flutter/material.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:storifuel/widgets/auth/custom_textfield.dart';
import 'package:storifuel/widgets/common/custom_app_bar.dart';
import 'package:storifuel/widgets/common/round_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  
  const ForgotPasswordScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: context.screenHeight * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAppBar(),
              const SizedBox(height: 90),
              Text("Forgot Password", style: nunitoSans24w700),
              const SizedBox(height: 50),
              CustomTextField(labelText: "Email", controller: controller),
              const SizedBox(height: 20),
              Text('Please enter your email, we will send you',style: nunitoSans16w400),
              Text('a link to reset your password',style: nunitoSans16w400),
              const Spacer(),
              RoundButton(text: "Send Link", onPressed: () {
                Navigator.pushNamed(context, '/check-email');
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}