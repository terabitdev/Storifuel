import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: nunito14w500,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: SvgPicture.asset(
                      AppImages.editIcon,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onDelete,
                    child: SvgPicture.asset(
                      AppImages.trashIcon,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


