import 'package:flutter/material.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class ProfileCustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool readOnly;

  const ProfileCustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: nunito14w600,
        ),
        const SizedBox(height: 8),
        TextField(
          style: nunito14w500.copyWith(
            color: readOnly ? Colors.grey.shade600 : Colors.black,
          ),
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: readOnly ? Colors.grey.shade100 : Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: readOnly ? Colors.grey.shade300 : outlineInputColor
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: readOnly ? Colors.grey.shade300 : secondaryColor
              ),
            ),
          ),
      )]);
  }
}