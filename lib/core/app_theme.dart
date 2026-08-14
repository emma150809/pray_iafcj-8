import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Tema oficial de Pray IAFCJ.
/// Aquí definimos la apariencia general de la aplicación.
class AppTheme {
  // Tema claro de la aplicación.
  static ThemeData get lightTheme {
    return ThemeData(
      // Material Design 3
      useMaterial3: true,

      // Color principal de la app
      primaryColor: AppColors.primary,

      // Color de fondo general
      scaffoldBackgroundColor: AppColors.background,

      // Fuente por defecto de la aplicación.
      // Los títulos seguirán usando AppTextStyles.
      fontFamily: 'Cormorant',

      //-----------------------------------------
      // AppBar
      //-----------------------------------------
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
      ),

      //-----------------------------------------
      // Notificaciones (SnackBar)
      //-----------------------------------------
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        insetPadding: EdgeInsets.fromLTRB(16, 0, 16, 110),
      ),

      //-----------------------------------------
      // Botones
      //-----------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.card,

          minimumSize: const Size(180, 50),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),

          textStyle: AppTextStyles.button,
        ),
      ),

      //-----------------------------------------
      // Campos de texto
      //-----------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: AppColors.card,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: AppColors.border),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: AppColors.border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
