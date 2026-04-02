import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color bg = Color(0xFFF5F0D0);
  static const Color bgDot = Color(0xFFB8C0D8);
  static const Color shell = Color(0xFFFAF5EA);
  static const Color shellBorder = Color(0xFFD8CDB5);
  static const Color screen = Color(0x99FFFFFC); // rgba(255,255,252,0.6)
  static const Color screenBorder = Color(0xFFD0C8B0);
  static const Color text = Color(0xFF6A6880);
  static const Color textMuted = Color(0xFF9890A0);
  static const Color textWarm = Color(0xFFA09880);
  static const Color title = Color(0xFF9090B0);
  static const Color subtitle = Color(0xFFB0A890);
  static const Color tab = Color(0xFFEDE8D4);
  static const Color tabActive = Color(0xFFFAF6E8);
  static const Color tabBorder = Color(0xFFC8C0A8);
  static const Color tabActiveBorder = Color(0xFFA8A0C0);
  static const Color accent = Color(0xFF8080A8);
  static const Color btnAdd = Color(0xFFD8E8C8);
  static const Color btnAddBorder = Color(0xFFB0C8A0);
  static const Color btnAddText = Color(0xFF708060);
  static const Color btnReset = Color(0xFFE8D0C8);
  static const Color btnResetBorder = Color(0xFFC8B0A8);
  static const Color btnResetText = Color(0xFF907870);
  static const Color sectionBorder = Color(0xFFC8C0A8);
  static const Color inputBg = Color(0xFFFAF6E8);
  static const Color inputBorder = Color(0xFFC8C0A8);
  static const Color inputText = Color(0xFF7A7868);
  static const Color star = Color(0xFFC8B8A0);
  static const Color dotEmpty = Color(0xFFEFE8D0);
  static const Color dotBorder = Color(0xFFD0C8B0);
}

class AppFonts {
  AppFonts._();

  /// Pixel-style font (Silkscreen).
  static TextStyle pixel({
    double fontSize = 14,
    Color color = AppColors.text,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.silkscreen(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }

  /// Dot-matrix-style font (DotGothic16).
  static TextStyle dot({
    double fontSize = 14,
    Color color = AppColors.text,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.dotGothic16(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}

class AppTheme {
  AppTheme._();

  /// Default 6x6 pastel color palette.
  static const List<List<String>> defaultPalette = [
    ['#F8B4B4', '#F8D0A0', '#F8E8A0', '#C8E8A0', '#A0D8E8', '#C0B8E8'],
    ['#F4A0A0', '#F4C088', '#F4D888', '#B0D888', '#88C8D8', '#A8A0D8'],
    ['#E88888', '#E8A870', '#E8C870', '#98C870', '#70B0C8', '#9088C8'],
    ['#D87070', '#D89058', '#D8B058', '#80B058', '#5898B0', '#7870B0'],
    ['#C85858', '#C87840', '#C89840', '#689840', '#408098', '#605898'],
    ['#B84040', '#B86030', '#B88030', '#508030', '#306880', '#484080'],
  ];

  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        surface: AppColors.shell,
        onSurface: AppColors.text,
      ),
      textTheme: TextTheme(
        bodyLarge: AppFonts.dot(fontSize: 16),
        bodyMedium: AppFonts.dot(fontSize: 14),
        bodySmall: AppFonts.dot(fontSize: 12, color: AppColors.textMuted),
        titleLarge: AppFonts.pixel(fontSize: 20, color: AppColors.title),
        titleMedium: AppFonts.pixel(fontSize: 16, color: AppColors.title),
        titleSmall: AppFonts.pixel(fontSize: 14, color: AppColors.subtitle),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBg,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.inputBorder),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.inputBorder),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        hintStyle: AppFonts.dot(fontSize: 14, color: AppColors.textMuted),
        labelStyle: AppFonts.dot(fontSize: 14, color: AppColors.inputText),
      ),
    );
  }
}
