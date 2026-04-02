import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const SettingsScreen({
    super.key,
    required this.onBack,
  });

  static const String _version = '1.0.0';
  static const String _aboutUrl = 'https://mydiandian.app/about';
  static const String _contactUrl = 'https://mydiandian.app/contact';
  static const String _privacyUrl = 'https://mydiandian.app/privacy';
  static const String _termsUrl = 'https://mydiandian.app/terms';

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        '<',
                        style: AppFonts.pixel(
                          fontSize: 20,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    lang.t('settings.title'),
                    style: AppFonts.pixel(
                      fontSize: 18,
                      color: AppColors.title,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Language section
                    _buildSectionTitle(lang.t('settings.language')),
                    const SizedBox(height: 8),
                    _buildLanguageSelector(context, lang),

                    const SizedBox(height: 24),

                    // Links section
                    _buildSectionTitle('Links'),
                    const SizedBox(height: 8),
                    _buildLinkTile(
                      label: lang.t('settings.about'),
                      onTap: () => _openUrl(_aboutUrl),
                    ),
                    _buildLinkTile(
                      label: lang.t('settings.contact'),
                      onTap: () => _openUrl(_contactUrl),
                    ),
                    _buildLinkTile(
                      label: lang.t('settings.privacy'),
                      onTap: () => _openUrl(_privacyUrl),
                    ),
                    _buildLinkTile(
                      label: lang.t('settings.terms'),
                      onTap: () => _openUrl(_termsUrl),
                    ),

                    const SizedBox(height: 24),

                    // Version
                    Center(
                      child: Text(
                        '${lang.t('settings.version')} $_version',
                        style: AppFonts.dot(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Account section
                    _buildSectionTitle(lang.t('settings.account')),
                    const SizedBox(height: 12),

                    // Logout
                    _buildActionButton(
                      context: context,
                      label: lang.t('settings.logout'),
                      bgColor: AppColors.inputBg,
                      borderColor: AppColors.inputBorder,
                      textColor: AppColors.text,
                      onTap: () => _handleLogout(context, lang),
                    ),
                    const SizedBox(height: 12),

                    // Delete account
                    _buildActionButton(
                      context: context,
                      label: lang.t('settings.deleteAccount'),
                      bgColor: AppColors.btnReset,
                      borderColor: AppColors.btnResetBorder,
                      textColor: AppColors.btnResetText,
                      onTap: () => _handleDeleteAccount(context, lang),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppFonts.pixel(fontSize: 13, color: AppColors.subtitle),
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    LanguageProvider lang,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.shell,
        border: Border.all(color: AppColors.shellBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildLanguageOption(
            context,
            lang: lang,
            language: Language.fr,
            label: lang.t('settings.french'),
          ),
          _buildLanguageOption(
            context,
            lang: lang,
            language: Language.en,
            label: lang.t('settings.english'),
          ),
          _buildLanguageOption(
            context,
            lang: lang,
            language: Language.zhCN,
            label: lang.t('settings.chineseSimplified'),
          ),
          _buildLanguageOption(
            context,
            lang: lang,
            language: Language.zhTW,
            label: lang.t('settings.chineseTraditional'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required LanguageProvider lang,
    required Language language,
    required String label,
  }) {
    final isActive = lang.lang == language;
    return GestureDetector(
      onTap: () => lang.setLang(language),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.tabActive : Colors.transparent,
          border: isActive
              ? Border.all(color: AppColors.tabActiveBorder)
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: AppFonts.dot(
            fontSize: 14,
            color: isActive ? AppColors.accent : AppColors.text,
          ),
        ),
      ),
    );
  }

  Widget _buildLinkTile({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.shell,
          border: Border.all(color: AppColors.shellBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppFonts.dot(fontSize: 14, color: AppColors.text),
            ),
            Text(
              '>',
              style: AppFonts.pixel(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            label,
            style: AppFonts.pixel(fontSize: 13, color: textColor),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    LanguageProvider lang,
  ) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: lang.t('settings.logout'),
      message: lang.t('settings.logoutConfirm'),
      confirmLabel: lang.t('common.yes'),
      cancelLabel: lang.t('common.cancel'),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
    }
  }

  Future<void> _handleDeleteAccount(
    BuildContext context,
    LanguageProvider lang,
  ) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: lang.t('settings.deleteAccount'),
      message: lang.t('settings.deleteAccountConfirm'),
      confirmLabel: lang.t('common.delete'),
      cancelLabel: lang.t('common.cancel'),
      destructive: true,
    );

    if (confirmed == true && context.mounted) {
      try {
        await ApiService().apiFetch('/api/auth/account', method: 'DELETE');
        if (context.mounted) {
          await context.read<AuthProvider>().logout();
        }
      } catch (e) {
        debugPrint('Delete account failed: $e');
      }
    }
  }
}
