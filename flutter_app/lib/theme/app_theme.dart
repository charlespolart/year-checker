import 'package:flutter/material.dart';

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
    return TextStyle(
      fontFamily: 'Silkscreen',
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
    return TextStyle(
      fontFamily: 'DotGothic16',
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
    ['#FFE5EC', '#FFE8D6', '#FFF9DB', '#E6F4EA', '#E7F5FF', '#F3F0FF'],
    ['#FFC2D1', '#FFD1B0', '#FFF3BF', '#C7E9C0', '#D0EBFF', '#E5DBFF'],
    ['#FF9EB8', '#FFBA8A', '#FFEC99', '#A8D8A8', '#A5D8FF', '#D0BFFF'],
    ['#FF7AA0', '#FFA364', '#FFE066', '#7BC47F', '#74C0FC', '#B197FC'],
    ['#FF5C8A', '#FF8C42', '#FFD43B', '#4CAF50', '#4DABF7', '#9775FA'],
    ['#E8456B', '#E06A20', '#E6B800', '#2E7D32', '#1976D2', '#6A1FC0'],
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
