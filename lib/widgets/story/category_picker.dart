import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/view_model/story/story_provider.dart';
import 'package:storifuel/widgets/common/round_button.dart';

class CategoryPicker extends StatelessWidget {
  const CategoryPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoryProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories', style: nunitoSans16w400.copyWith(color: const Color(0xFF111827))),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _openSelectBottomSheet(context, provider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    provider.selectedCategory ?? 'Select Categories',
                    style: provider.selectedCategory == null
                        ? outfit14w400.copyWith(color: const Color(0xFF626262))
                        : nunito14w500,
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _openAddBottomSheet(context, provider),
          child: Row(
            children: [
              SvgPicture.asset(AppImages.octagonPlusIcon),
              const SizedBox(width: 10),
              Text('Add New Category', style: outfit14w500.copyWith(color: secondaryColor)),
            ],
          ),
        )
      ],
    );
  }

  void _openSelectBottomSheet(BuildContext context, StoryProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ChangeNotifierProvider<StoryProvider>.value(
          value: provider,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Consumer<StoryProvider>(
              builder: (context, p, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 56,
                        height: 6,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Center(child: Text('Select Categories', style: nunitoSans16w700.copyWith(color: const Color(0xFF0F182E)))),
                    const SizedBox(height: 20),
                    ...p.availableCategories.map((c) => _SelectableRow(
                          label: c,
                          isSelected: p.selectedCategory == c,
                          onTap: () => p.selectCategory(c),
                        )),
                    const SizedBox(height: 24),
                    RoundButton(
                      text: 'Select',
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _openAddBottomSheet(BuildContext context, StoryProvider provider) {
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 56,
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Center(child: Text('Add New Category', style: poppins18w600)),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Write a Category…',
                  hintStyle: outfit14w400,
                  filled: true,
                  fillColor: primaryColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: outlineInputColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: outlineInputColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    provider.addCategory(controller.text);
                    Navigator.pop(context);
                    _openSelectBottomSheet(context, provider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Add', style: nunitoSans16w700),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SelectableRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: nunitoSans16w700.copyWith(color: const Color(0xFF0F182E)),
                ),
              ),
              _CheckIcon(isSelected: isSelected)
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckIcon extends StatelessWidget {
  final bool isSelected;
  const _CheckIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: isSelected ? const Color(0xFF35B34A) : const Color(0xFFE0E0E0), width: 2),
        color: isSelected ? const Color(0xFF35B34A) : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}


