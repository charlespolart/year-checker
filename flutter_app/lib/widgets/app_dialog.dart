import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// App-wide dialog wrapper with max width constraint for landscape.
class AppDialog extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AppDialog({
    super.key,
    required this.child,
    this.maxWidth = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.shell,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.shellBorder),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
