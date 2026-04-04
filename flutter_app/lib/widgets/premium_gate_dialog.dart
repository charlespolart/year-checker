import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/premium_provider.dart';
import '../theme/app_theme.dart';
import 'app_dialog.dart';

/// Dialog shown when a free user tries to access a premium feature.
/// Shows what premium includes and an upgrade button.
class PremiumGateDialog extends StatelessWidget {
  final String feature;

  const PremiumGateDialog({super.key, required this.feature});

  /// Shows the dialog. Returns true if the user upgraded (for testing).
  static Future<bool> show(BuildContext context, {required String feature}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => PremiumGateDialog(feature: feature),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();

    return AppDialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Crown icon
            Icon(Icons.workspace_premium, size: 36, color: AppColors.accent),
            const SizedBox(height: 12),

            // Title
            Text(
              lang.t('premium.title'),
              style: AppFonts.pixel(fontSize: 18, color: AppColors.title),
            ),
            const SizedBox(height: 16),

            // Feature being gated
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.screen,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.screenBorder),
              ),
              child: Text(
                feature,
                style: AppFonts.dot(fontSize: 13, color: AppColors.text),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Benefits list
            _buildBenefit(Icons.grid_view, lang.t('premium.feature.trackers')),
            _buildBenefit(Icons.palette, lang.t('premium.feature.themes')),
            _buildBenefit(Icons.pets, lang.t('premium.feature.cursor')),
            _buildBenefit(Icons.image, lang.t('premium.feature.export')),

            const SizedBox(height: 20),

            // Upgrade button
            GestureDetector(
              onTap: () {
                // Placeholder: toggle premium for testing
                context.read<PremiumProvider>().setPremium(true);
                Navigator.of(context).pop(true);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    lang.t('premium.upgrade'),
                    style: AppFonts.pixel(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Restore purchases
            GestureDetector(
              onTap: () {
                // Placeholder: will connect to store
                Navigator.of(context).pop(false);
              },
              child: Text(
                lang.t('premium.restore'),
                style: AppFonts.dot(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 8),

            // Cancel
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text(
                lang.t('common.cancel'),
                style: AppFonts.pixel(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildBenefit(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppFonts.dot(fontSize: 13, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}
