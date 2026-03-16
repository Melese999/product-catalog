import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.gold,
          primary: AppColors.gold,
          secondary: AppColors.goldDark,
          surface: AppColors.surfaceLight,
          error: AppColors.error,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.bgLight,
        cardTheme: const CardThemeData(
          color: AppColors.surfaceLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: AppColors.borderLight, width: 0.5),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: AppTextStyles.h3.copyWith(
            color: AppColors.textLightPrimary,
            fontWeight: FontWeight.w900,
          ),
          centerTitle: true,
        ),
        textTheme: TextTheme(
          displayLarge: AppTextStyles.h1.copyWith(color: AppColors.textLightPrimary),
          displayMedium: AppTextStyles.h2.copyWith(color: AppColors.textLightPrimary),
          titleLarge: AppTextStyles.h3.copyWith(color: AppColors.textLightPrimary),
          bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textLightPrimary),
          bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLightPrimary),
          bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textLightSecondary),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.borderLight,
          thickness: 1,
          space: 1,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.gold,
          primary: AppColors.gold,
          secondary: AppColors.goldLight,
          surface: AppColors.surfaceDark,
          error: AppColors.error,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.bgDark,
        cardTheme: const CardThemeData(
          color: AppColors.surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: AppColors.borderDark, width: 0.5),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: AppTextStyles.h3.copyWith(
            color: AppColors.gold,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
          centerTitle: true,
        ),
        textTheme: TextTheme(
          displayLarge: AppTextStyles.h1.copyWith(color: AppColors.textDarkPrimary),
          displayMedium: AppTextStyles.h2.copyWith(color: AppColors.textDarkPrimary),
          titleLarge: AppTextStyles.h3.copyWith(color: AppColors.gold),
          bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textDarkPrimary),
          bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDarkPrimary),
          bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textDarkSecondary),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.borderDark,
          thickness: 1,
          space: 1,
        ),
      );
}
