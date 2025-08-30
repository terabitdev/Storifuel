import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/utils/toast.dart';
import 'package:storifuel/view_model/Auth/auth_provider.dart';
import 'package:storifuel/widgets/common/round_button.dart';
import 'package:storifuel/widgets/profile/profile_textfield.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // removes back arrow
        elevation: 0,
        centerTitle: true,
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
              RoundButton(text: "Save", onPressed: () {}),
              const SizedBox(height: 32),
              RoundButton(text: "Logout", onPressed: () {
                showLogoutDialog(context);
              })
            ],
          ),
        ),
      ),
    );
  }
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: nunito14w500,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: BorderSide(
                          color: secondaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: nunito12w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            foregroundColor: primaryColor,
                          ),
                          onPressed: authProvider.isLoading ? null : () async {
                            // Close dialog first
                            Navigator.of(dialogContext).pop();
                            
                            // Perform logout
                            await _handleLogout(context, authProvider);
                          },
                          child: authProvider.isLoading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Logout",
                                style: nunito12w400.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _handleLogout(BuildContext context, AuthProvider authProvider) async {
  try {
    // Perform logout
    await authProvider.signOut();
    
    // Navigate to sign-in screen and clear navigation stack
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/sign-in',
        (route) => false,
      );
      
      // Show success message
      showSuccessToast(context, 'Logged out successfully');
    }
  } catch (e) {
    // Show error if logout fails
    if (context.mounted) {
      showErrorToast(context, 'Failed to logout. Please try again.');
    }
  }
}