import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static const Color _primaryDark = Color(0xFF0D0D0D);
  static const Color _surfaceDark = Color(0xFF1A1A1A);
  static const Color _cardDark = Color(0xFF242424);
  static const Color _accent = Color(0xFFE50914);
  static const Color _accentLight = Color(0xFFFF6B6B);
  static const Color _textPrimary = Color(0xFFF5F5F5);
  static const Color _textSecondary = Color(0xFF9E9E9E);
  static const Color _divider = Color(0xFF2C2C2C);

  static const Color _primaryLight = Color(0xFFF8F8F8);
  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _cardLight = Color(0xFFF0F0F0);
  static const Color _textPrimaryLight = Color(0xFF0D0D0D);
  static const Color _textSecondaryLight = Color(0xFF6B6B6B);
  static const Color _dividerLight = Color(0xFFE0E0E0);

  static ThemeData dark() {
    final base = ThemeData.dark();
    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: _primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: _accent,
        secondary: _accentLight,
        surface: _surfaceDark,
        onSurface: _textPrimary,
        onPrimary: Colors.white,
      ),
      cardTheme: const CardThemeData(
        color: _cardDark,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      dividerColor: _divider,
      textTheme: _buildTextTheme(base.textTheme, _textPrimary, _textSecondary),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: _textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceDark,
        selectedItemColor: _accent,
        unselectedItemColor: _textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _cardDark,
        selectedColor: _accent.withOpacity(0.2),
        labelStyle: GoogleFonts.inter(color: _textPrimary, fontSize: 13),
        side: const BorderSide(color: _divider),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.inter(color: _textSecondary, fontSize: 15),
      ),
    );
  }

  static ThemeData light() {
    final base = ThemeData.light();
    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: _primaryLight,
      colorScheme: const ColorScheme.light(
        primary: _accent,
        secondary: _accentLight,
        surface: _surfaceLight,
        onSurface: _textPrimaryLight,
        onPrimary: Colors.white,
      ),
      cardTheme: const CardThemeData(
        color: _cardLight,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      dividerColor: _dividerLight,
      textTheme: _buildTextTheme(base.textTheme, _textPrimaryLight, _textSecondaryLight),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: _textPrimaryLight,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: _textPrimaryLight),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceLight,
        selectedItemColor: _accent,
        unselectedItemColor: _textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  static TextTheme _buildTextTheme(
    TextTheme base,
    Color primary,
    Color secondary,
  ) {
    return base.copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        color: primary, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        color: primary, fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        color: primary, fontSize: 20, fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.spaceGrotesk(
        color: primary, fontSize: 16, fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.inter(
        color: primary, fontSize: 14, fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(color: primary, fontSize: 16, height: 1.6),
      bodyMedium: GoogleFonts.inter(color: secondary, fontSize: 14, height: 1.5),
      bodySmall: GoogleFonts.inter(color: secondary, fontSize: 12),
      labelLarge: GoogleFonts.inter(
        color: primary, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2,
      ),
    );
  }
}
