import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/widgets/category/category_card.dart';
import 'package:storifuel/widgets/category/edit_category_bottom_sheet.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> categories = [
    "Business",
    "Crypto",
    "Technology",
  ];

  void _showEditCategoryBottomSheet(int index) {
    EditCategoryBottomSheet.show(
      context,
      initialText: categories[index],
    ).then((result) {
      if (result != null && result.isNotEmpty) {
        setState(() {
          categories[index] = result;
        });
      }
    });
  }

  void _showAddCategoryBottomSheet() {
    EditCategoryBottomSheet.show(
      context,
      initialText: "",
    ).then((result) {
      if (result != null && result.isNotEmpty) {
        setState(() {
          categories.add(result);
        });
      }
    });
  }

  void _showDeleteCategoryBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 6,
              margin: EdgeInsets.only(top: 12, bottom: 32),
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Delete Category',
              style: nunitoSans16w700.copyWith(color: Colors.black),
            ),
            SizedBox(height: 16),
            Center(child: SvgPicture.asset(AppImages.deleteIcon, width: 66, height: 66)),
            SizedBox(height: 16),
            Text(
              'Are you sure you want to delete?',
              style: nunitoSans16w400,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: secondaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style:nunitoSans16w700.copyWith(color:secondaryColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: nunitoSans16w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: secondaryColor,
        onPressed: _showAddCategoryBottomSheet,
        child: SvgPicture.asset(AppImages.plusIcon),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(child: Image.asset(AppImages.logo1, width: 118, height: 32)),
              const SizedBox(height: 24),
              Center(child: Text("All Categories", style: nunitoSans18w700)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      title: categories[index],
                      onEdit: () => _showEditCategoryBottomSheet(index),
                      onDelete: () => _showDeleteCategoryBottomSheet(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}