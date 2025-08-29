import 'package:flutter/material.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:toastification/toastification.dart';

void _showThemedToast({
  required BuildContext context,
  required String title,
  required String message,
  required IconData icon,
  required ToastificationType type,
}) {
  final theme = Theme.of(context);

  toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.flatColored,
    autoCloseDuration: const Duration(seconds: 3),
    title: Text(
      title,
      style: nunito14w600,
    ),
    description: Text(
      message,
      style: nunito12w400,
    ),
    alignment: Alignment.topCenter,
    animationDuration: const Duration(milliseconds: 300),
    icon: Icon(icon, color: theme.primaryColor, size: 24),
    showIcon: true,
    backgroundColor: primaryColor,
    foregroundColor: theme.colorScheme.onSurface,
    primaryColor: theme.primaryColor,
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: theme.colorScheme.secondary, width: 1.5),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    showProgressBar: false,
    dragToClose: true,
    applyBlurEffect: false,
  );
}

void showSuccessToast(BuildContext context, String message, {String? title}) {
  _showThemedToast(
    context: context,
    title: title ?? 'Success',
    message: message,
    icon: Icons.check_circle,
    type: ToastificationType.success,
  );
}

void showErrorToast(BuildContext context, String message, {String? title}) {
  _showThemedToast(
    context: context,
    title: title ?? 'Error',
    message: message,
    icon: Icons.error_outline_outlined,
    type: ToastificationType.error,
  );
}

void showWarningToast(BuildContext context, String title, String message) {
  _showThemedToast(
    context: context,
    title: title,
    message: message,
    icon: Icons.warning,
    type: ToastificationType.warning,
  );
}

void showInfoToast(BuildContext context, String title, String message) {
  _showThemedToast(
    context: context,
    title: title,
    message: message,
    icon: Icons.info,
    type: ToastificationType.info,
  );
}
