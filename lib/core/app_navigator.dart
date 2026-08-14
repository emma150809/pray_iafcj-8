import 'package:flutter/cupertino.dart';

///==============================================================
/// Navegador personalizado
///
/// Provee transiciones de pantalla personalizadas para una
/// experiencia de usuario más fluida.
///==============================================================
class AppNavigator {
  AppNavigator._();

  static Route<T> spa<T>(Widget page) {
    // Usamos CupertinoPageRoute para una transición de deslizamiento
    // horizontal. Es una animación limpia, rápida y universalmente
    // reconocida que no se siente brusca.
    return CupertinoPageRoute<T>(builder: (context) => page);
  }

  /// Reemplaza todo el stack de navegación con [page] usando
  /// la transición `spa`.
  static Future<void> pushAndRemoveUntil(BuildContext context, Widget page) {
    return Navigator.of(
      context,
    ).pushAndRemoveUntil(AppNavigator.spa(page), (route) => false);
  }
}
