import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/utils/toast.dart';
import 'package:storifuel/view_model/category/category_provider.dart';
import 'package:storifuel/widgets/category/add_category_sheet.dart';
import 'package:storifuel/widgets/category/category_card.dart';
import 'package:storifuel/widgets/category/edit_category_bottom_sheet.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  void _showEditCategoryBottomSheet(String categoryId, String currentName) {
    EditCategoryBottomSheet.show(
      context,
      initialText: currentName,
    ).then((result) async {
      if (result != null && result.isNotEmpty) {
        // ignore: use_build_context_synchronously
        final categoryProvider = context.read<CategoryProvider>();
        final success = await categoryProvider.updateCategory(categoryId, result);
        if (success) {
          // ignore: use_build_context_synchronously
          showSuccessToast(context, 'Category updated successfully');
        } else {
          // ignore: use_build_context_synchronously
          showErrorToast(context, categoryProvider.errorMessage ?? 'Failed to update category');
        }
      }
    });
  }

  void _showAddCategoryBottomSheet() {
    AddCategoryBottomSheet.show(
      context,
      initialText: "",
    ).then((result) async {
      if (result != null && result.isNotEmpty) {
        // ignore: use_build_context_synchronously
        final categoryProvider = context.read<CategoryProvider>();
        
        // Check if category already exists
        if (categoryProvider.categoryExists(result)) {
          // ignore: use_build_context_synchronously
          showInfoToast(context, 'Category already exists', 'Please choose a different name');
          return;
        }
        
        final success = await categoryProvider.createCategory(result);
        if (success) {
          // ignore: use_build_context_synchronously
          showSuccessToast(context, 'Category created successfully');
        } else {
          // ignore: use_build_context_synchronously
          showErrorToast(context, categoryProvider.errorMessage ?? 'Failed to create category');
        }
      }
    });
  }

  void _showDeleteCategoryBottomSheet(String categoryId, String categoryName) {
    final categoryProvider = context.read<CategoryProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
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
                          Navigator.pop(bottomSheetContext);
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
                        onPressed: () async {
                          Navigator.pop(bottomSheetContext);
                          
                          final success = await categoryProvider.deleteCategory(categoryId);
                          if (mounted) {
                            if (success) {
                              showInfoToast(context, 'Deleted', 'Category deleted successfully');
                            } else {
                              showErrorToast(context, categoryProvider.errorMessage ?? 'Failed to delete category');
                            }
                          }
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
                child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    if (categoryProvider.isLoading && categoryProvider.categories.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(color: secondaryColor),
                      );
                    }
                    
                    if (!categoryProvider.hasCategories) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No categories created yet',
                              style: nunitoSans16w400.copyWith(
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the + button to add your first category',
                              style: nunitoSans16w400.copyWith(
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: categoryProvider.refreshCategories,
                      color: secondaryColor,
                      child: ListView.builder(
                        itemCount: categoryProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = categoryProvider.categories[index];
                          return CategoryCard(
                            title: category['name'] ?? 'Unknown',
                            onEdit: () => _showEditCategoryBottomSheet(
                              category['id'],
                              category['name'] ?? '',
                            ),
                            onDelete: () => _showDeleteCategoryBottomSheet(
                              category['id'],
                              category['name'] ?? '',
                            ),
                          );
                        },
                      ),
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