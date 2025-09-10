import 'package:flutter/material.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/widgets/common/round_button.dart';

class EditCategoryBottomSheet {
  static Future<String?> show(BuildContext context, {String? initialText}) {
    final TextEditingController controller = TextEditingController(text: initialText ?? "");
    
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
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
              // Handle indicator
              Container(
                width: 40,
                height: 6,
                margin: EdgeInsets.only(top: 12, bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Text(
                'Edit Category',
                style: nunitoSans16w700.copyWith(color: Colors.black),
              ),
              
              SizedBox(height: 32),
              
              // Text Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    style: nunitoSans16w400,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Enter category name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RoundButton(
                  text: "Update",
                  onPressed: () {
                    String updatedText = controller.text.trim();
                    if (updatedText.isNotEmpty) {
                      Navigator.pop(context, updatedText);
                    }
                  },
                ),
              ),
              
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}