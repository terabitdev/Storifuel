import 'package:flutter/material.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class PDFProgressDialog extends StatelessWidget {
  final String message;
  final double? progress; // 0.0 to 1.0, null for indeterminate
  
  const PDFProgressDialog({
    super.key,
    required this.message,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // PDF Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                size: 30,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              'Generating PDF',
              style: poppins18w600.copyWith(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            
            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: nunito14w500.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Progress Indicator
            if (progress != null)
              Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress! * 100).toInt()}%',
                    style: nunito12w400.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            else
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  /// Shows the PDF progress dialog
  static void show(BuildContext context, {required String message, double? progress}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PDFProgressDialog(
        message: message,
        progress: progress,
      ),
    );
  }

  /// Hides the currently shown dialog
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Updates the dialog with new message and progress
  static void update(BuildContext context, {required String message, double? progress}) {
    // Close current dialog and show new one
    Navigator.of(context).pop();
    show(context, message: message, progress: progress);
  }
}