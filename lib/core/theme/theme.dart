import 'package:flutter/material.dart';

// Modern & Futuristic, Real-world Usable Theme
const _bg = Color(0xFF181C24);
const _surface = Color(0xFF202534);
const _card = Color(0xFF232A3A);
const _text = Color(0xFFF3F6FC);
const _textMuted = Color(0xFF8CA0B3);
const _primary = Color(0xFF4FC3F7);
const _primaryDark = Color(0xFF1976D2);
const _accent = Color(0xFF6C8EFF);
const _error = Color(0xFFFF4D4F);
const _warning = Color(0xFFFACC15);
const _border = Color(0xFF232A3A);
const _divider = Color(0xFF202534);
const _radius = 16.0;
const _radiusSm = 10.0;
const _shadow = [
  BoxShadow(
    color: Colors.black26,
    blurRadius: 18,
    offset: Offset(0, 6),
  ),
];

final appTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: _primary,
    onPrimary: Colors.black,
    primaryContainer: _primaryDark,
    secondary: _accent,
    onSecondary: _text,
    error: _error,
    onError: _text,
    background: _bg,
    onBackground: _text,
    surface: _surface,
    onSurface: _text,
    outline: _border,
  ),
  scaffoldBackgroundColor: _bg,
  cardColor: _card,
  fontFamily: 'Inter',
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _text, fontFamily: 'Inter', letterSpacing: 0.1),
    titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _text, fontFamily: 'Inter'),
    bodyLarge: TextStyle(fontSize: 16, color: _text, fontFamily: 'Inter'),
    bodyMedium: TextStyle(fontSize: 14, color: _textMuted, fontFamily: 'Inter'),
    bodySmall: TextStyle(fontSize: 12.5, color: _textMuted, fontFamily: 'Inter'),
    labelLarge: TextStyle(fontSize: 13, color: _textMuted, fontFamily: 'Inter', fontWeight: FontWeight.w600),
    labelSmall: TextStyle(fontSize: 11, color: _textMuted, fontFamily: 'Inter'),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _surface.withOpacity(0.98),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _text, fontFamily: 'Inter'),
    iconTheme: const IconThemeData(color: _primary),
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(_radius)),
      side: BorderSide(color: _border, width: 1.1),
    ),
    toolbarHeight: 58,
  ),
  cardTheme: CardThemeData(
    color: _card,
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  ),
  dividerColor: _divider.withOpacity(0.55),
  iconTheme: const IconThemeData(color: _textMuted, size: 22),
  listTileTheme: ListTileThemeData(
    textColor: _text,
    iconColor: _textMuted,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusSm)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(_radiusSm), borderSide: BorderSide(color: _border.withOpacity(0.18))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_radiusSm), borderSide: BorderSide(color: _border.withOpacity(0.18))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_radiusSm), borderSide: BorderSide(color: _primary, width: 2)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_radiusSm), borderSide: BorderSide(color: _error)),
    filled: true,
    fillColor: _surface.withOpacity(0.98),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    hintStyle: TextStyle(color: _textMuted, fontFamily: 'Inter'),
    labelStyle: TextStyle(color: _textMuted, fontFamily: 'Inter'),
    prefixIconColor: _textMuted,
    suffixIconColor: _textMuted,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: _primary.withOpacity(0.13),
    labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: _primary, fontFamily: 'Inter'),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusSm)),
    side: BorderSide(color: _border.withOpacity(0.13)),
    selectedColor: _primary,
    checkmarkColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _primary,
    foregroundColor: Colors.black,
    shape: StadiumBorder(),
    elevation: 6,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: _card.withOpacity(0.98),
    contentTextStyle: const TextStyle(fontSize: 16, color: _text, fontFamily: 'Inter'),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusSm)),
    behavior: SnackBarBehavior.floating,
    elevation: 6,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: _surface,
    selectedItemColor: _primary,
    unselectedItemColor: _textMuted,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
    unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.normal, fontFamily: 'Inter'),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: _card,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusSm)),
    elevation: 6,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: _card,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
    titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _text, fontFamily: 'Inter'),
    contentTextStyle: const TextStyle(fontSize: 14, color: _textMuted, fontFamily: 'Inter'),
  ),
);

// 현대적+미래적 감성의 서비스 특화 전역 CSS (Glassmorphism/Soft UI/Deep Dark/Vibrant Accent/Interactive)
// final csColorBg ...
// final csColorSurface ...
// final csColorGlass ...
// final csColorCard ...
// final csColorText ...
// final csColorTextMuted ...
// final csColorPrimary ...
// final csColorPrimaryDark ...
// final csColorAccent ...
// final csColorAccentVivid ...
// final csColorWarning ...
// final csColorError ...
// final csColorBorder ...
// final csColorDivider ...
// final csRadiusSm ...
// final csRadiusMd ...
// final csRadiusLg ...
// final csShadowSoft ...
// final csShadowGlass ...
// final csGradientBg ...
// final csGlassBlur ...
// final csTheme ...

// --- World-class Enterprise Design System: csTheme ---
// 컬러 팔레트: 명확한 계층, 확장성, 브랜드 일관성
class CsColors {
  static const primary = Color(0xFF4FC3F7);
  static const primaryDark = Color(0xFF1976D2);
  static const accent = Color(0xFF6C8EFF);
  static const accentVivid = Color(0xFF6C8EFF);
  static const surface = Color(0xFF202534);
  static const surfaceElevated = Color(0xFF232A3A);
  static const glass = Color(0x1A232A3A);
  static const background = Color(0xFF181C24);
  static const card = Color(0xFF232A3A);
  static const border = Color(0xFF232A3A);
  static const divider = Color(0xFF202534);
  static const text = Color(0xFFF3F6FC);
  static const textMuted = Color(0xFF8CA0B3);
  static const success = Color(0xFF4ADE80);
  static const warning = Color(0xFFFACC15);
  static const error = Color(0xFFFF4D4F);
  static const info = Color(0xFF60A5FA);
  static const overlay = Color(0xCC181A20);
}

// Spacing, Radius, Depth, Animation
class CsSpacing {
  static const xs = 6.0;
  static const sm = 12.0;
  static const md = 18.0;
  static const lg = 28.0;
  static const xl = 40.0;
}
class CsRadius {
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}
class CsShadow {
  static final soft = [
    BoxShadow(
      color: CsColors.primary.withOpacity(0.06),
      blurRadius: 32,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.18),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
  static final glass = [
    BoxShadow(
      color: CsColors.accent.withOpacity(0.08),
      blurRadius: 40,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];
}
class CsBorder {
  static BorderSide subtle = BorderSide(color: CsColors.border.withOpacity(0.13), width: 1.2);
  static BorderSide strong = BorderSide(color: CsColors.border.withOpacity(0.22), width: 1.6);
}

// Typography: 계층적, 브랜드 일관성
class CsTypography {
  static const titleLarge = TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: CsColors.text, fontFamily: 'Inter', letterSpacing: 0.1);
  static const titleMedium = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: CsColors.text, fontFamily: 'Inter', letterSpacing: 0.05);
  static const bodyLarge = TextStyle(fontSize: 16, color: CsColors.text, fontFamily: 'Inter');
  static const bodyMedium = TextStyle(fontSize: 14, color: CsColors.textMuted, fontFamily: 'Inter');
  static const bodySmall = TextStyle(fontSize: 12.5, color: CsColors.textMuted, fontFamily: 'Inter');
  static const label = TextStyle(fontSize: 13, color: CsColors.textMuted, fontFamily: 'Inter', fontWeight: FontWeight.w600);
  static const caption = TextStyle(fontSize: 11, color: CsColors.textMuted, fontFamily: 'Inter');
}

// Gradient, Glass, Animation
final csGradientBg = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    CsColors.background,
    CsColors.surface,
    CsColors.primary.withOpacity(0.04),
    CsColors.accent.withOpacity(0.03),
  ],
  stops: const [0.0, 0.6, 0.85, 1.0],
);
final csGlassBlur = 18.0;

final csTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: CsColors.primary,
    onPrimary: Colors.black,
    primaryContainer: CsColors.primaryDark,
    secondary: CsColors.accent,
    onSecondary: CsColors.text,
    error: CsColors.error,
    onError: CsColors.text,
    background: CsColors.background,
    onBackground: CsColors.text,
    surface: CsColors.surface,
    onSurface: CsColors.text,
    outline: CsColors.border,
  ),
  scaffoldBackgroundColor: CsColors.background,
  cardColor: CsColors.card,
  fontFamily: 'Inter',
  textTheme: const TextTheme(
    titleLarge: CsTypography.titleLarge,
    titleMedium: CsTypography.titleMedium,
    bodyLarge: CsTypography.bodyLarge,
    bodyMedium: CsTypography.bodyMedium,
    bodySmall: CsTypography.bodySmall,
    labelLarge: CsTypography.label,
    labelSmall: CsTypography.caption,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: CsColors.surface.withOpacity(0.92),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: CsTypography.titleLarge,
    iconTheme: const IconThemeData(color: CsColors.primary),
    shadowColor: CsColors.primary.withOpacity(0.10),
    surfaceTintColor: Colors.white24,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      side: BorderSide(color: CsColors.border, width: 1.2),
    ),
    toolbarHeight: 60,
  ),
  cardTheme: CardThemeData(
    color: CsColors.card,
    elevation: 8,
    shadowColor: CsColors.accentVivid.withOpacity(0.10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CsRadius.lg)),
    margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
  ),
  dividerColor: CsColors.divider.withOpacity(0.55),
  iconTheme: const IconThemeData(color: CsColors.textMuted, size: 22),
  listTileTheme: ListTileThemeData(
    textColor: CsColors.text,
    iconColor: CsColors.textMuted,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CsRadius.md)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(CsRadius.md), borderSide: CsBorder.subtle),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(CsRadius.md), borderSide: CsBorder.subtle),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(CsRadius.md), borderSide: BorderSide(color: CsColors.primary, width: 2)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(CsRadius.md), borderSide: BorderSide(color: CsColors.error)),
    filled: true,
    fillColor: CsColors.surface.withOpacity(0.98),
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
    hintStyle: CsTypography.bodyMedium,
    labelStyle: CsTypography.label,
    prefixIconColor: CsColors.textMuted,
    suffixIconColor: CsColors.textMuted,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: CsColors.accent.withOpacity(0.13),
    labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: CsColors.accent, fontFamily: 'Inter'),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CsRadius.md)),
    side: CsBorder.subtle,
    selectedColor: CsColors.primary,
    checkmarkColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: CsColors.primary,
    foregroundColor: Colors.black,
    shape: StadiumBorder(),
    elevation: 8,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: CsColors.card.withOpacity(0.98),
    contentTextStyle: CsTypography.bodyLarge,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CsRadius.md)),
    behavior: SnackBarBehavior.floating,
    elevation: 8,
  ),
); 