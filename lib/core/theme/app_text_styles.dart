import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle urbanist({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.urbanist(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle displayLarge({Color? color}) => urbanist(
        fontSize: 40,
        fontWeight: FontWeight.w800, // Extra Bold
        color: color ?? AppColors.black,
        letterSpacing: -1.0,
        height: 1.2,
      );

  static TextStyle displayMedium({Color? color}) => urbanist(
        fontSize: 34,
        fontWeight: FontWeight.w700, // Bold
        color: color ?? AppColors.black,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle displaySmall({Color? color}) => urbanist(
        fontSize: 28,
        fontWeight: FontWeight.w700, // Bold
        color: color ?? AppColors.black,
        letterSpacing: -0.5,
        height: 1.25,
      );

  static TextStyle headlineLarge({Color? color}) => urbanist(
        fontSize: 24,
        fontWeight: FontWeight.w700, // Bold
        color: color ?? AppColors.black,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle headlineMedium({Color? color}) => urbanist(
        fontSize: 22,
        fontWeight: FontWeight.w600, // SemiBold
        color: color ?? AppColors.black,
        letterSpacing: -0.2,
        height: 1.3,
      );

  static TextStyle headlineSmall({Color? color}) => urbanist(
        fontSize: 20,
        fontWeight: FontWeight.w600, // SemiBold
        color: color ?? AppColors.black,
        letterSpacing: 0,
        height: 1.35,
      );

  static TextStyle titleLarge({Color? color}) => urbanist(
        fontSize: 18,
        fontWeight: FontWeight.w600, // SemiBold
        color: color ?? AppColors.black,
        letterSpacing: 0,
        height: 1.4,
      );

  static TextStyle titleMedium({Color? color}) => urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w600, // SemiBold
        color: color ?? AppColors.black,
        letterSpacing: 0.1,
        height: 1.4,
      );

  static TextStyle titleSmall({Color? color}) => urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w600, // SemiBold
        color: color ?? AppColors.black,
        letterSpacing: 0.1,
        height: 1.4,
      );

  static TextStyle bodyLarge({Color? color}) => urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w400, // Regular
        color: color ?? AppColors.black,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle bodyMedium({Color? color}) => urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w400, // Regular
        color: color ?? AppColors.black,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle bodySmall({Color? color}) => urbanist(
        fontSize: 12,
        fontWeight: FontWeight.w400, // Regular
        color: color ?? AppColors.gray700,
        letterSpacing: 0.3,
        height: 1.4,
      );

  static TextStyle labelLarge({Color? color}) => urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w700, // Bold
        color: color ?? AppColors.black,
        letterSpacing: 0.5,
        height: 1.2,
      );

  static TextStyle labelMedium({Color? color}) => urbanist(
        fontSize: 12,
        fontWeight: FontWeight.w600, // SemiBold
        color: color ?? AppColors.black,
        letterSpacing: 0.5,
        height: 1.2,
      );

  static TextStyle labelSmall({Color? color}) => urbanist(
        fontSize: 10,
        fontWeight: FontWeight.w500, // Medium
        color: color ?? AppColors.gray700,
        letterSpacing: 0.5,
        height: 1.2,
      );

  static TextTheme createTextTheme({required Color primaryColor, required Color secondaryColor}) {
    return TextTheme(
      displayLarge: displayLarge(color: primaryColor),
      displayMedium: displayMedium(color: primaryColor),
      displaySmall: displaySmall(color: primaryColor),
      headlineLarge: headlineLarge(color: primaryColor),
      headlineMedium: headlineMedium(color: primaryColor),
      headlineSmall: headlineSmall(color: primaryColor),
      titleLarge: titleLarge(color: primaryColor),
      titleMedium: titleMedium(color: primaryColor),
      titleSmall: titleSmall(color: primaryColor),
      bodyLarge: bodyLarge(color: primaryColor),
      bodyMedium: bodyMedium(color: primaryColor),
      bodySmall: bodySmall(color: secondaryColor),
      labelLarge: labelLarge(color: primaryColor),
      labelMedium: labelMedium(color: primaryColor),
      labelSmall: labelSmall(color: secondaryColor),
    );
  }
}
