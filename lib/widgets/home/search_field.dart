import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onFilterTap;

  const SearchWidget({
    super.key, 
    required this.controller, 
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: textfieldbgocolor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        style: poppins14w400.copyWith(color: const Color(0xFF0F182E)),
        controller: controller,
        onChanged: onChanged,
        onSubmitted: (value) {
          FocusScope.of(context).unfocus();
          onSubmitted?.call(value);
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(AppImages.searchIcon),
          ),
          suffixIcon: GestureDetector(
            onTap: onFilterTap,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(AppImages.filterIcon),
            ),
          ),
          hintText: "Search stories",
          hintStyle: poppins14w400,
        ),
      ),
    );
  }
}
