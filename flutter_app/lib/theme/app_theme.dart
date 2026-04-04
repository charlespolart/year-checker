import 'package:flutter/material.dart';

enum AppThemeType { defaultTheme, ocean, sakura, forest, sunset, midnight, noir }

const appThemeNames = {
  AppThemeType.defaultTheme: 'Default',
  AppThemeType.ocean: 'Ocean',
  AppThemeType.sakura: 'Sakura',
  AppThemeType.forest: 'Forest',
  AppThemeType.sunset: 'Sunset',
  AppThemeType.midnight: 'Midnight',
  AppThemeType.noir: 'Noir',
};

class AppThemeColors {
  final Color bg, bgDot, shell, shellBorder, screen, screenBorder;
  final Color text, textMuted, textWarm, title, subtitle;
  final Color tab, tabActive, tabBorder, tabActiveBorder;
  final Color accent;
  final Color btnAdd, btnAddBorder, btnAddText;
  final Color btnReset, btnResetBorder, btnResetText;
  final Color sectionBorder, inputBg, inputBorder, inputText;
  final Color star, dotEmpty, dotBorder;

  const AppThemeColors({
    required this.bg, required this.bgDot, required this.shell,
    required this.shellBorder, required this.screen, required this.screenBorder,
    required this.text, required this.textMuted, required this.textWarm,
    required this.title, required this.subtitle,
    required this.tab, required this.tabActive, required this.tabBorder,
    required this.tabActiveBorder, required this.accent,
    required this.btnAdd, required this.btnAddBorder, required this.btnAddText,
    required this.btnReset, required this.btnResetBorder, required this.btnResetText,
    required this.sectionBorder, required this.inputBg, required this.inputBorder,
    required this.inputText, required this.star, required this.dotEmpty,
    required this.dotBorder,
  });
}

const _themes = <AppThemeType, AppThemeColors>{
  AppThemeType.defaultTheme: AppThemeColors(
    bg: Color(0xFFF5F0D0), bgDot: Color(0xFFB8C0D8),
    shell: Color(0xFFFAF5EA), shellBorder: Color(0xFFD8CDB5),
    screen: Color(0x99FFFFFC), screenBorder: Color(0xFFD0C8B0),
    text: Color(0xFF6A6880), textMuted: Color(0xFF9890A0), textWarm: Color(0xFFA09880),
    title: Color(0xFF9090B0), subtitle: Color(0xFFB0A890),
    tab: Color(0xFFEDE8D4), tabActive: Color(0xFFFAF6E8),
    tabBorder: Color(0xFFC8C0A8), tabActiveBorder: Color(0xFFA8A0C0),
    accent: Color(0xFF8080A8),
    btnAdd: Color(0xFFD8E8C8), btnAddBorder: Color(0xFFB0C8A0), btnAddText: Color(0xFF708060),
    btnReset: Color(0xFFE8D0C8), btnResetBorder: Color(0xFFC8B0A8), btnResetText: Color(0xFF907870),
    sectionBorder: Color(0xFFC8C0A8), inputBg: Color(0xFFFAF6E8),
    inputBorder: Color(0xFFC8C0A8), inputText: Color(0xFF7A7868),
    star: Color(0xFFC8B8A0), dotEmpty: Color(0xFFEFE8D0), dotBorder: Color(0xFFD0C8B0),
  ),
  AppThemeType.ocean: AppThemeColors(
    bg: Color(0xFFD8E8F0), bgDot: Color(0xFF90B0C8),
    shell: Color(0xFFE8F0F5), shellBorder: Color(0xFFB0C8D8),
    screen: Color(0x99F0F8FF), screenBorder: Color(0xFFA8C0D0),
    text: Color(0xFF405060), textMuted: Color(0xFF708898), textWarm: Color(0xFF607080),
    title: Color(0xFF4080A0), subtitle: Color(0xFF6898B0),
    tab: Color(0xFFD0E0E8), tabActive: Color(0xFFE0F0F8),
    tabBorder: Color(0xFFA0B8C8), tabActiveBorder: Color(0xFF5090B0),
    accent: Color(0xFF3078A0),
    btnAdd: Color(0xFFC0E0D8), btnAddBorder: Color(0xFF80C0A8), btnAddText: Color(0xFF306050),
    btnReset: Color(0xFFE0C8C0), btnResetBorder: Color(0xFFC0A8A0), btnResetText: Color(0xFF806060),
    sectionBorder: Color(0xFFA0B8C8), inputBg: Color(0xFFE8F0F5),
    inputBorder: Color(0xFFA0B8C8), inputText: Color(0xFF405868),
    star: Color(0xFF88A8B8), dotEmpty: Color(0xFFD0E0E8), dotBorder: Color(0xFFB0C8D0),
  ),
  AppThemeType.sakura: AppThemeColors(
    bg: Color(0xFFFCF0F0), bgDot: Color(0xFFD8B0C0),
    shell: Color(0xFFFFF5F5), shellBorder: Color(0xFFE0C0C8),
    screen: Color(0x99FFF8F8), screenBorder: Color(0xFFD8B8C0),
    text: Color(0xFF684858), textMuted: Color(0xFFA08090), textWarm: Color(0xFF987080),
    title: Color(0xFFB06080), subtitle: Color(0xFFC08898),
    tab: Color(0xFFF0E0E4), tabActive: Color(0xFFFFF0F2),
    tabBorder: Color(0xFFD0B0B8), tabActiveBorder: Color(0xFFC07088),
    accent: Color(0xFFC06080),
    btnAdd: Color(0xFFE8D0D8), btnAddBorder: Color(0xFFD0A8B0), btnAddText: Color(0xFF806068),
    btnReset: Color(0xFFE8C8C0), btnResetBorder: Color(0xFFC8A8A0), btnResetText: Color(0xFF907068),
    sectionBorder: Color(0xFFD0B0B8), inputBg: Color(0xFFFFF5F5),
    inputBorder: Color(0xFFD0B0B8), inputText: Color(0xFF685058),
    star: Color(0xFFD0A8B0), dotEmpty: Color(0xFFF0E0E4), dotBorder: Color(0xFFD8C0C8),
  ),
  AppThemeType.forest: AppThemeColors(
    bg: Color(0xFFE0E8D8), bgDot: Color(0xFF98A890),
    shell: Color(0xFFECF0E8), shellBorder: Color(0xFFC0C8B0),
    screen: Color(0x99F8FFF0), screenBorder: Color(0xFFB0B8A0),
    text: Color(0xFF404838), textMuted: Color(0xFF708068), textWarm: Color(0xFF687860),
    title: Color(0xFF506840), subtitle: Color(0xFF788868),
    tab: Color(0xFFD8E0D0), tabActive: Color(0xFFE8F0E0),
    tabBorder: Color(0xFFA8B0A0), tabActiveBorder: Color(0xFF608050),
    accent: Color(0xFF508040),
    btnAdd: Color(0xFFD0E0C0), btnAddBorder: Color(0xFFA0C090), btnAddText: Color(0xFF506040),
    btnReset: Color(0xFFE0D0C0), btnResetBorder: Color(0xFFC0B0A0), btnResetText: Color(0xFF807060),
    sectionBorder: Color(0xFFA8B0A0), inputBg: Color(0xFFECF0E8),
    inputBorder: Color(0xFFA8B0A0), inputText: Color(0xFF485040),
    star: Color(0xFFA8B098), dotEmpty: Color(0xFFD8E0D0), dotBorder: Color(0xFFB8C0B0),
  ),
  AppThemeType.sunset: AppThemeColors(
    bg: Color(0xFFF8E8D8), bgDot: Color(0xFFC8A898),
    shell: Color(0xFFFFF0E8), shellBorder: Color(0xFFD8C0A8),
    screen: Color(0x99FFF8F0), screenBorder: Color(0xFFD0B8A0),
    text: Color(0xFF604840), textMuted: Color(0xFF987868), textWarm: Color(0xFFA08868),
    title: Color(0xFFA06840), subtitle: Color(0xFFB88860),
    tab: Color(0xFFF0E0D0), tabActive: Color(0xFFFFF0E0),
    tabBorder: Color(0xFFC8B0A0), tabActiveBorder: Color(0xFFB07848),
    accent: Color(0xFFB07040),
    btnAdd: Color(0xFFE0D8C0), btnAddBorder: Color(0xFFC8B898), btnAddText: Color(0xFF706048),
    btnReset: Color(0xFFE8C8C0), btnResetBorder: Color(0xFFC8A8A0), btnResetText: Color(0xFF906860),
    sectionBorder: Color(0xFFC8B0A0), inputBg: Color(0xFFFFF0E8),
    inputBorder: Color(0xFFC8B0A0), inputText: Color(0xFF685040),
    star: Color(0xFFC8A890), dotEmpty: Color(0xFFF0E0D0), dotBorder: Color(0xFFD8C8B0),
  ),
  AppThemeType.midnight: AppThemeColors(
    bg: Color(0xFF1A1A2E), bgDot: Color(0xFF2A2A48),
    shell: Color(0xFF222240), shellBorder: Color(0xFF3A3A58),
    screen: Color(0x99181830), screenBorder: Color(0xFF3A3A58),
    text: Color(0xFFB0B0D0), textMuted: Color(0xFF7878A0), textWarm: Color(0xFF9898B8),
    title: Color(0xFF9090D0), subtitle: Color(0xFF7878B0),
    tab: Color(0xFF252548), tabActive: Color(0xFF2E2E50),
    tabBorder: Color(0xFF3A3A58), tabActiveBorder: Color(0xFF6060A0),
    accent: Color(0xFF7070C0),
    btnAdd: Color(0xFF2A3A48), btnAddBorder: Color(0xFF3A5068), btnAddText: Color(0xFF80B0C8),
    btnReset: Color(0xFF3A2828), btnResetBorder: Color(0xFF583838), btnResetText: Color(0xFFC08080),
    sectionBorder: Color(0xFF3A3A58), inputBg: Color(0xFF222240),
    inputBorder: Color(0xFF3A3A58), inputText: Color(0xFF9898B8),
    star: Color(0xFF5858A0), dotEmpty: Color(0xFF252548), dotBorder: Color(0xFF3A3A58),
  ),
  AppThemeType.noir: AppThemeColors(
    bg: Color(0xFF121212), bgDot: Color(0xFF222222),
    shell: Color(0xFF1A1A1A), shellBorder: Color(0xFF333333),
    screen: Color(0x99181818), screenBorder: Color(0xFF333333),
    text: Color(0xFFD0D0D0), textMuted: Color(0xFF888888), textWarm: Color(0xFFA0A0A0),
    title: Color(0xFFE0E0E0), subtitle: Color(0xFF999999),
    tab: Color(0xFF1E1E1E), tabActive: Color(0xFF252525),
    tabBorder: Color(0xFF333333), tabActiveBorder: Color(0xFF666666),
    accent: Color(0xFF999999),
    btnAdd: Color(0xFF1E2E1E), btnAddBorder: Color(0xFF2E4E2E), btnAddText: Color(0xFF80A880),
    btnReset: Color(0xFF2E1E1E), btnResetBorder: Color(0xFF4E2E2E), btnResetText: Color(0xFFA88080),
    sectionBorder: Color(0xFF333333), inputBg: Color(0xFF1A1A1A),
    inputBorder: Color(0xFF333333), inputText: Color(0xFFB0B0B0),
    star: Color(0xFF555555), dotEmpty: Color(0xFF1E1E1E), dotBorder: Color(0xFF333333),
  ),
};

/// Mutable color accessors — updated by ThemeProvider.
class AppColors {
  AppColors._();

  static AppThemeColors _current = _themes[AppThemeType.defaultTheme]!;

  static void setTheme(AppThemeType type) {
    _current = _themes[type]!;
  }

  static AppThemeColors colorsFor(AppThemeType type) => _themes[type]!;

  static Color get bg => _current.bg;
  static Color get bgDot => _current.bgDot;
  static Color get shell => _current.shell;
  static Color get shellBorder => _current.shellBorder;
  static Color get screen => _current.screen;
  static Color get screenBorder => _current.screenBorder;
  static Color get text => _current.text;
  static Color get textMuted => _current.textMuted;
  static Color get textWarm => _current.textWarm;
  static Color get title => _current.title;
  static Color get subtitle => _current.subtitle;
  static Color get tab => _current.tab;
  static Color get tabActive => _current.tabActive;
  static Color get tabBorder => _current.tabBorder;
  static Color get tabActiveBorder => _current.tabActiveBorder;
  static Color get accent => _current.accent;
  static Color get btnAdd => _current.btnAdd;
  static Color get btnAddBorder => _current.btnAddBorder;
  static Color get btnAddText => _current.btnAddText;
  static Color get btnReset => _current.btnReset;
  static Color get btnResetBorder => _current.btnResetBorder;
  static Color get btnResetText => _current.btnResetText;
  static Color get sectionBorder => _current.sectionBorder;
  static Color get inputBg => _current.inputBg;
  static Color get inputBorder => _current.inputBorder;
  static Color get inputText => _current.inputText;
  static Color get star => _current.star;
  static Color get dotEmpty => _current.dotEmpty;
  static Color get dotBorder => _current.dotBorder;
}

class AppFonts {
  AppFonts._();

  static TextStyle pixel({
    double fontSize = 14,
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontFamily: 'Silkscreen',
      fontSize: fontSize,
      color: color ?? AppColors.text,
      fontWeight: fontWeight,
    );
  }

  static TextStyle dot({
    double fontSize = 14,
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontFamily: 'DotGothic16',
      fontSize: fontSize,
      color: color ?? AppColors.text,
      fontWeight: fontWeight,
    );
  }
}

class AppTheme {
  AppTheme._();

  static const List<List<String>> defaultPalette = [
    ['#FFE5EC', '#FFE8D6', '#FFF9DB', '#E6F4EA', '#E7F5FF', '#F3F0FF'],
    ['#FFC2D1', '#FFD1B0', '#FFF3BF', '#C7E9C0', '#D0EBFF', '#E5DBFF'],
    ['#FF9EB8', '#FFBA8A', '#FFEC99', '#A8D8A8', '#A5D8FF', '#D0BFFF'],
    ['#FF7AA0', '#FFA364', '#FFE066', '#7BC47F', '#74C0FC', '#B197FC'],
    ['#FF5C8A', '#FF8C42', '#FFD43B', '#4CAF50', '#4DABF7', '#9775FA'],
    ['#E8456B', '#E06A20', '#E6B800', '#2E7D32', '#1976D2', '#6A1FC0'],
  ];

  static ThemeData themeDataFor(AppThemeType type) {
    final c = AppColors.colorsFor(type);
    return ThemeData(
      scaffoldBackgroundColor: c.bg,
      colorScheme: ColorScheme.light(
        primary: c.accent,
        surface: c.shell,
        onSurface: c.text,
      ),
      textTheme: TextTheme(
        bodyLarge: AppFonts.dot(fontSize: 16, color: c.text),
        bodyMedium: AppFonts.dot(fontSize: 14, color: c.text),
        bodySmall: AppFonts.dot(fontSize: 12, color: c.textMuted),
        titleLarge: AppFonts.pixel(fontSize: 20, color: c.title),
        titleMedium: AppFonts.pixel(fontSize: 16, color: c.title),
        titleSmall: AppFonts.pixel(fontSize: 14, color: c.subtitle),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.inputBg,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: c.inputBorder),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: c.inputBorder),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: c.accent, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        hintStyle: AppFonts.dot(fontSize: 14, color: c.textMuted),
        labelStyle: AppFonts.dot(fontSize: 14, color: c.inputText),
      ),
    );
  }
}
