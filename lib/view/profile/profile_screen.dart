import 'package:flutter/material.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/widgets/common/round_button.dart';
import 'package:storifuel/widgets/profile/profile_textfield.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false, // removes back arrow
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: nunitoSans18w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                    backgroundColor: Color(0xFFE0E7FF), 
                  ),
                  Positioned(
                    right: 4,
                    child: Image.asset(
                      "assets/images/image-edit.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 32),
              ProfileCustomTextField(label: "Full name", hint: "Enter your full name"),
              const SizedBox(height: 16),
              ProfileCustomTextField(label: "Email", hint: "Enter your email"),
              const SizedBox(height: 140),
              RoundButton(text: "Save", onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
