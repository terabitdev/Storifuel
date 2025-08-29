import 'package:flutter/material.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';

class StoryOptionsPopup extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onExportPDF;

  const StoryOptionsPopup({
    super.key,
    this.onEdit,
    this.onExportPDF,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit option
          InkWell(
            onTap: () {
              Navigator.pop(context);
              onEdit?.call();
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.messageEditIcon, // your custom edit/message svg
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Edit',
                    style: nunito14w500.copyWith(color: const Color(0xFF1A237E)),
                  ),
                ],
              ),
            ),
          ),
          // Divider
          Container(
            height: 1,
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          // Export PDF option
          InkWell(
            onTap: () {
              Navigator.pop(context);
              onExportPDF?.call();
            },
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppImages.pdfIcon, // your custom pdf svg
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Export PDF',
                    style: nunito14w500.copyWith(color: const Color(0xFF1A237E)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show(
    BuildContext context, {
    VoidCallback? onEdit,
    VoidCallback? onExportPDF,
  }) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return Stack(
          children: [
            Positioned(
              right: 16,
              top: position.bottom + 5,
              child: Material(
                color: Colors.transparent,
                child: StoryOptionsPopup(
                  onEdit: onEdit,
                  onExportPDF: onExportPDF,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
